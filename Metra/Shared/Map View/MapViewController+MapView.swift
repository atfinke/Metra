//
//  MapViewController+MapView.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? VehiclePositionAnnotation else { return nil }
        return annotation.annotationView()
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? RoutePolyline else {
            fatalError()
        }

        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        let color = System.shared.color(for: overlay.routeID) ?? UIColor.white
        polyLineRenderer.strokeColor = color
        polyLineRenderer.lineWidth = 2.0

        return polyLineRenderer
    }
}
