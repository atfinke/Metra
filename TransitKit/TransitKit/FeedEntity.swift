//
//  FeedEntity.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/**
 A definition (or update) of an entity in the transit feed. If the entity is not being deleted, exactly one of 'trip_update', 'vehicle' and 'alert' fields should be populated.
 */
public struct TSTRTFeedEntity {

    /**
     Feed-unique identifier for this entity. The ids are used only to provide incrementality support. The actual entities referenced by the feed must be specified by explicit selectors (see EntitySelector below for more info).
     */
    public let id: String

    /// Data about the realtime departure delays of a trip.
    public let tripUpdate: TSTRTTripUpdate?
    /// Data about the realtime position of a vehicle.
    public let vehiclePosition: TSTRTVehiclePosition?
    /// Data about the realtime alert.
    public let alert: TSTRTAlert?
}
