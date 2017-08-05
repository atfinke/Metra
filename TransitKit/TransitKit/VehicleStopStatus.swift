//
//  VehicleStopStatus.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/// - incoming: The vehicle is just about to arrive at the stop (on a stop display, the vehicle symbol typically flashes).
/// - stoppedAt: The vehicle is standing at the stop.
/// - inTransit: The vehicle has departed the previous stop and is in transit.
public enum TSTRTVehicleStopStatus: Int {
    case incoming = 0, stoppedAt, inTransit
}
