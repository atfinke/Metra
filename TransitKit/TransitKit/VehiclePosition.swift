//
//  VehiclePosition.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
/// Realtime positioning information for a given vehicle.
public struct TSTRTVehiclePosition {

    /**
     The Trip that this vehicle is serving. Can be empty or partial if the vehicle can not be identified with a given trip instance.
     */
    public let trip: TSTRTTripDescriptor?

    /**
     Additional information on the vehicle that is serving this trip. Each entry should have a unique vehicle id.
     */
    public let vehicle: TSTRTVehicleDescriptor?

    /// Current position of this vehicle.
    public let position: TSTRTPosition?

    /**
     The stop sequence index of the current stop. The meaning of current_stop_sequence (i.e., the stop that it refers to) is determined by current_status. If current_status is missing IN_TRANSIT_TO is assumed.
     */
    public let currentStopSequence: Int?

    /**
     Identifies the current stop. The value must be the same as in stops.txt in the corresponding GTFS feed.
     */
    public let stopID: String?

    /**
     The exact status of the vehicle with respect to the current stop. Ignored if current_stop_sequence is missing.
     */
    public let currentStatus: TSTRTVehicleStopStatus

    /**
     Moment at which the vehicle's position was measured. In POSIX time (i.e., number of seconds since January 1st 1970 00:00:00 UTC).
     */
    public let timestamp: Date

    public let congestionLevel: TSTRTCongestionLevel?

    /**
     The degree of passenger occupancy of the vehicle.
     Caution: this field is still experimental, and subject to change. It may be formally adopted in the future.
     */
    let occupancyStatus: TSTRTOccupancyStatus?
}
