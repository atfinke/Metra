//
//  VehiclePositionAnnotation.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import MapKit
import TransitKit

class VehiclePositionAnnotation: MKPointAnnotation {

    // MARK: - Properties

    public var isUpdated = false
    private(set) var vehiclePosition: TSTRTVehiclePosition

    // MARK: - Initalization

    init?(vehiclePosition: TSTRTVehiclePosition) {
        guard let coordinate = vehiclePosition.position?.coordinate,
            let label = vehiclePosition.vehicle?.label else {
                return nil
        }
        self.vehiclePosition = vehiclePosition
        super.init()
        self.title = label
        self.coordinate = coordinate
    }

    // MARK: - Helpers

    func update(vehiclePosition newVehiclePosition: TSTRTVehiclePosition) -> Bool {
        guard let coordinate = newVehiclePosition.position?.coordinate,
            let label = vehiclePosition.vehicle?.label else {
                return false
        }

        UIView.animate(withDuration: 1.0) {
            self.coordinate = coordinate
        }

        self.title = label
        vehiclePosition = newVehiclePosition
        return true
    }

    func annotationView() -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "Pin")
        annotationView.centerOffset = CGPoint(x: -46, y: -86)

        let backgroundColor = System.shared.color(for: vehiclePosition.trip?.routeID) ?? UIColor.white
        var textColor = UIColor.black

        let component = backgroundColor.cgColor.components!
        let brightness = ((component[0] * 299) + (component[1] * 587) + (component[2] * 114)) / 1000

        if brightness < 0.75 {
            textColor = UIColor.white
        }

        let pinView = VehiclePinView(color: backgroundColor)
        pinView.frame = CGRect(x: 0, y: 0, width: 92, height: 117)
        pinView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        annotationView.addSubview(pinView)

        let label = UILabel(frame: CGRect(x: 23, y: 37.5, width: 45, height: 30))
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = textColor
        label.text = vehiclePosition.vehicle?.label
        annotationView.addSubview(label)

        return annotationView
    }

}
