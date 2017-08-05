//
//  Position.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation
import CoreLocation

/// A geographic position of a vehicle.
public struct TSTRTPosition {

    /// Degrees North, in the WGS-84 coordinate system.
    public let latitude: Float
    /// Degrees East, in the WGS-84 coordinate system.
    public let longitude: Float

    /**
     Bearing, in degrees, clockwise from True North, i.e., 0 is North and 90 is East. This can be the compass bearing, or the direction towards the next stop or intermediate location. This should not be deduced from the sequence of previous positions, which clients can compute from previous data.
     */
    public let bearing: Float?

    /// Odometer value, in meters.
    public let odometer: Double?

    /// Momentary speed measured by the vehicle, in meters per second.
    public let speed: Float?
}

extension TSTRTPosition {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}
