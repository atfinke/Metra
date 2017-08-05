//
//  TripDescriptor.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/**
 A descriptor that identifies an instance of a GTFS trip, or all instances of a trip along a route. To specify a single trip instance, the trip_id (and if necessary, start_time) is set. If route_id is also set, then it should be same as one that the given trip corresponds to. To specify all the trips along a given route, only the route_id should be set. Note that if the trip_id is not known, then station sequence ids in TripUpdate are not sufficient, and stop_ids must be provided as well. In addition, absolute arrival/departure times must be provided.
 */
public struct TSTRTTripDescriptor {

    /**
     The trip_id from the GTFS feed that this selector refers to. For non frequency-based trips, this field is enough to uniquely identify the trip. For frequency-based trip, start_time and start_date might also be necessary.
     */
    public let tripID: String

    /// The route_id from the GTFS that this selector refers to.
    public let routeID: String

    /**
     The direction_id from the GTFS feed trips.txt file, indicating the direction of travel for trips this selector refers to.
     Caution: this field is still experimental, and subject to change. It may be formally adopted in the future.
     */
    public let directionID: Int?

    /**
     The initially scheduled start time of this trip instance. When the trip_id corresponds to a non-frequency-based trip, this field should either be omitted or be equal to the value in the GTFS feed. When the trip_id correponds to a frequency-based trip, the start_time must be specified for trip updates and vehicle positions. If the trip corresponds to exact_times=1 GTFS record, then start_time must be some multiple (including zero) of headway_secs later than frequencies.txt start_time for the corresponding time period. If the trip corresponds to exact_times=0, then its start_time may be arbitrary, and is initially expected to be the first departure of the trip. Once established, the start_time of this frequency-based trip should be considered immutable, even if the first departure time changes -- that time change may instead be reflected in a StopTimeUpdate. Format and semantics of the field is same as that of GTFS/frequencies.txt/start_time, e.g., 11:15:35 or 25:15:35.
     */
    public let startTime: String?

    /**
     The scheduled start date of this trip instance. This field must be provided to disambiguate trips that are so late as to collide with a scheduled trip on a next day. For example, for a train that departs 8:00 and 20:00 every day, and is 12 hours late, there would be two distinct trips on the same time. This field can be provided but is not mandatory for schedules in which such collisions are impossible - for example, a service running on hourly schedule where a vehicle that is one hour late is not considered to be related to schedule anymore. In YYYYMMDD format.
     */
    public let startDate: String?

    public let scheduleRelationship: TSTRTScheduleRelationship?
}
