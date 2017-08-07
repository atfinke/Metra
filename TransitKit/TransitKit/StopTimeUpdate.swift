//
//  StopTimeUpdate.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
/**
 Realtime update for arrival and/or departure events for a given stop on a trip. Please also refer to the general discussion of stop time updates in the TripDescriptor and trip updates entities documentation.

 Updates can be supplied for both past and future events. The producer is allowed, although not required, to drop past events. The update is linked to a specific stop either through stop_sequence or stop_id, so one of these fields must necessarily be set. If the same stop_id is visited more than once in a trip, then stop_sequence should be provided in all StopTimeUpdates for that stop_id on that trip.
 */
public struct TSTRTStopTimeUpdate {

    /// Must be the same as in stop_times.txt in the corresponding GTFS feed.
    public let stopSequence: Int?

    /// Must be the same as in stops.txt in the corresponding GTFS feed.
    public let stopID: String?
    public let arrival: TSTRTStopTimeEvent?
    public let departure: TSTRTStopTimeEvent?

    /// The default relationship is SCHEDULED.
    public let scheduleRelationship: TSTRTScheduleRelationship?
}
