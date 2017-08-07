//
//  TripUpdate.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
/**
 Realtime update on the progress of a vehicle along a trip. Please also refer to the general discussion of the trip updates entities.

 Depending on the value of ScheduleRelationship, a TripUpdate can specify:

 A trip that proceeds along the schedule.

 A trip that proceeds along a route but has no fixed schedule.

 A trip that has been added or removed with regard to schedule.

 The updates can be for future, predicted arrival/departure events, or for past events that already occurred. In most cases information about past events is a measured value thus its uncertainty value is recommended to be 0. Although there could be cases when this does not hold so it is allowed to have uncertainty value different from 0 for past events. If an update's uncertainty is not 0, either the update is an approximate prediction for a trip that has not completed or the measurement is not precise or the update was a prediction for the past that has not been verified after the event occurred.

 Note that the update can describe a trip that has already completed.To this end, it is enough to provide an update for the last stop of the trip. If the time of arrival at the last stop is in the past, the client will conclude that the whole trip is in the past (it is possible, although inconsequential, to also provide updates for preceding stops). This option is most relevant for a trip that has completed ahead of schedule, but according to the schedule, the trip is still proceeding at the current time. Removing the updates for this trip could make the client assume that the trip is still proceeding. Note that the feed provider is allowed, but not required, to purge past updates - this is one case where this would be practically useful.
 */
public struct TSTRTTripUpdate {

    /**
     The Trip that this message applies to. There can be at most one TripUpdate entity for each actual trip instance. If there is none, that means there is no prediction information available. It does not mean that the trip is progressing according to schedule.
     */
    public let trip: TSTRTTripDescriptor

    /// Additional information on the vehicle that is serving this trip.
    public let vehicle: TSTRTVehicleDescriptor?

    /**
     Updates to StopTimes for the trip (both future, i.e., predictions, and in some cases, past ones, i.e., those that already happened). The updates must be sorted by stop_sequence, and apply for all the following stops of the trip up to the next specified one.
     */
    public let stopTimeUpdates: [TSTRTStopTimeUpdate]

    /**
     Moment at which the vehicle's real-time progress was measured. In POSIX time (i.e., the number of seconds since January 1st 1970 00:00:00 UTC).
     */
    public let date: Date

    /**
     The current schedule deviation for the trip. Delay should only be specified when the prediction is given relative to some existing schedule in GTFS.
     Delay (in seconds) can be positive (meaning that the vehicle is late) or negative (meaning that the vehicle is ahead of schedule). Delay of 0 means that the vehicle is exactly on time.
     Delay information in StopTimeUpdates take precedent of trip-level delay information, such that trip-level delay is only propagated until the next stop along the trip with a StopTimeUpdate delay value specified.
     Feed providers are strongly encouraged to provide a TripUpdate.timestamp value indicating when the delay value was last updated, in order to evaluate the freshness of the data.
     Caution: this field is still experimental, and subject to change. It may be formally adopted in the future.
     */
    public let delay: Int?
}
