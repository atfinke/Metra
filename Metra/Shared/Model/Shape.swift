//
//  Shape.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import CSV
import MapKit

class RoutePolyline: MKPolyline {
    var routeID: String!
}

struct Shape {

    // MARK: - Properties

    let routeID: String
    let polyline: MKPolyline

    // MARK: - Initialization

    static func loadFromCSV() -> [Shape] {
        let path = Bundle.main.path(forResource: "shapes", ofType: "txt")!
        let stream = InputStream(fileAtPath: path)!
        guard let csv = try? CSV(stream: stream) else {
            fatalError()
        }
        _ = csv.next()

        var shapes = [Shape]()
        var shapeID: String?
        var coordinates = [CLLocationCoordinate2D]()

        while let row = csv.next() {
            if shapeID != row[0] {
                if let shapeID = shapeID {
                    let line = RoutePolyline(coordinates: coordinates, count: coordinates.count)
                    line.routeID = Shape.routeID(for: shapeID)
                    let shape = Shape(routeID: Shape.routeID(for: shapeID), polyline: line)
                    shapes.append(shape)
                }
                shapeID = row[0]
                coordinates = []
            }
            let coordinate = CLLocationCoordinate2D(latitude: Double(row[1])!, longitude: Double(row[2])!)
            coordinates.append(coordinate)
        }
        return shapes
    }

    // MARK: - Helpers

    private static func routeID(for shapeID: String) -> String {
        // swiftlint:disable:next line_length
        return ["UP-N_IB_1": "UP-N", "NCS_IB_2": "NCS", "ME_OB_2": "ME", "UP-W_IB_1": "UP-W", "ME_IB_2": "ME", "RI_OB_2": "RI", "MD-N_OB_1": "MD-N", "RI_IB_2": "RI", "UP-NW_OB_1": "UP-NW", "MD-N_IB_1": "MD-N", "UP-N_OB_1": "UP-N", "BNSF_IB_1": "BNSF", "RI_OB_1": "RI", "BNSF_OB_1": "BNSF", "MD-W_OB_1": "MD-W", "HC_OB_1": "HC", "NCS_OB_1": "NCS", "NCS_IB_1": "NCS", "UP-NW_OB_2": "UP-NW", "MD-W_IB_1": "MD-W", "ME_IB_1": "ME", "HC_IB_1": "HC", "ME_IB_3": "ME", "RI_IB_1": "RI", "ME_OB_1": "ME", "ME_OB_3": "ME", "SWS_IB_1": "SWS", "SWS_OB_1": "SWS", "UP-NW_IB_1": "UP-NW", "UP-NW_IB_2": "UP-NW", "UP-W_OB_1": "UP-W"][shapeID]!
    }

}
