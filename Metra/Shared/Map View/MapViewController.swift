//
//  MapViewController.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit
import MapKit
import TransitKit

class MapViewController: UIViewController {

    // MARK: - Interface

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let center = CLLocationCoordinate2D(latitude: 41.966381283429911, longitude: -87.987364628068335)
            let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 1.5)
            let region = MKCoordinateRegion(center: center, span: span)

            mapView.region = region
            mapView.delegate = self

            if ProcessInfo.processInfo.arguments.contains("TARGET_SCREENSHOTS") {
                mapView.showsUserLocation = true
            }
        }
    }

    // tvOS only
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?

    private var reloadBarButtonItem: UIBarButtonItem?
    private let loadingBarButtonItem: UIBarButtonItem? = {
        let activityView = UIActivityIndicatorView(style: .white)
        activityView.sizeToFit()
        activityView.startAnimating()

        #if os(tvOS)
            activityView.tintColor = .black
        #endif
        return UIBarButtonItem(customView: activityView)
    }()

    // MARK: - Properties

    private var hasShownAnnotations = false
    private let locationManager = CLLocationManager()

    private var allAnnotations = [VehiclePositionAnnotation]()
    private var visibleAnnotations = [VehiclePositionAnnotation]()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadBarButtonItem = navigationItem.rightBarButtonItem

        fetchTrainPositions()
        Timer.scheduledTimer(timeInterval: 30.0,
                             target: self,
                             selector: #selector(fetchTrainPositions),
                             userInfo: nil,
                             repeats: true)

        if ProcessInfo.processInfo.arguments.contains("TARGET_SCREENSHOTS") {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - Annotations

    @IBAction func fetchTrainPositions() {
        #if os(tvOS)
            activityIndicatorView?.startAnimating()
        #else
            navigationItem.rightBarButtonItem = loadingBarButtonItem
        #endif

        MetraDownloadTask.fetch(feed: .positions) { (entities) in
            var vehiclePositions = [String: TSTRTVehiclePosition]()
            for entry in entities ?? [] {
                if let vehiclePosition = entry.vehiclePosition, let label = vehiclePosition.vehicle?.label {
                    vehiclePositions[label] = vehiclePosition
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.updateAnnotations(with: vehiclePositions)

                #if os(tvOS)
                    self.activityIndicatorView?.stopAnimating()
                #else
                    self.navigationItem.rightBarButtonItem = self.reloadBarButtonItem
                #endif

                if let controller = self.navigationController?.visibleViewController,
                    controller.isKind(of: UIAlertController.self) {
                    return
                }

                if entities == nil {
                    // swiftlint:disable line_length
                    let alertController = UIAlertController(title: "Connection Issue",
                                                            message: "There was an issue connecting to Metra's servers.",
                                                            preferredStyle: .alert)

                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { _ in
                        self.fetchTrainPositions()
                    })

                    #if os(iOS)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(okAction)
                    #endif

                    alertController.addAction(retryAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }

    func updateAnnotations(with dictionary: [String: TSTRTVehiclePosition]) {
        allAnnotations.forEach { $0.isUpdated = false }
        for (key, value) in dictionary {
            if let annotation = allAnnotations.filter({ $0.vehiclePosition.vehicle?.label == key }).first {
                if annotation.update(vehiclePosition: value) {
                    annotation.isUpdated = true
                }
            } else if let annotation = VehiclePositionAnnotation(vehiclePosition: value) {
                annotation.isUpdated = true
                allAnnotations.append(annotation)
            }
        }
        for annotation in allAnnotations.filter({ !$0.isUpdated }) {
            if let index = allAnnotations.index(of: annotation) {
                allAnnotations.remove(at: index)
                mapView.removeAnnotation(annotation)
            } else {
                fatalError()
            }
        }

        updateFiltering()

        if !hasShownAnnotations {
            hasShownAnnotations = true
            if visibleAnnotations.count > 4 {
                mapView.showAnnotations(visibleAnnotations, animated: true)
            }
        }
    }

    func updateFiltering() {
        visibleAnnotations = []
        for annotation in allAnnotations {
            if let routeID = annotation.vehiclePosition.trip?.routeID, !MapFilter.shouldHide(routeID: routeID) {
                visibleAnnotations.append(annotation)
            } else {
                mapView.removeAnnotation(annotation)
            }
        }
        mapView.addAnnotations(visibleAnnotations)

        for shape in System.shared.shapes {
            if !MapFilter.shouldHidePath() && !MapFilter.shouldHide(routeID: shape.routeID) {
                mapView.addOverlay(shape.polyline)
            } else {
                mapView.removeOverlay(shape.polyline)
            }
        }
    }

}
