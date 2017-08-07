//
//  OccupancyStatus.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
/// The degree of passenger occupancy for the vehicle.
///
/// - empty: The vehicle is considered empty by most measures, and has few or no passengers onboard, but is still accepting passengers.
/// - manySeats: The vehicle has a large percentage of seats available. What percentage of free seats out of the total seats available is to be considered large enough to fall into this category is determined at the discretion of the producer.
/// - fewSeats: The vehicle has a small percentage of seats available. What percentage of free seats out of the total seats available is to be considered small enough to fall into this category is determined at the discretion of the producer.
/// - standingRoomOnly: The vehicle can currently accomodate only standing passengers.
/// - crushedStandingRoomOnly: The vehicle can currently accomodate only standing passengers and has limited space for them.
/// - full: The vehicle is considered full by most measures, but may still be allowing passengers to board.
/// - notAcceptingPassengers: The vehicle can not accept passengers.
public enum TSTRTOccupancyStatus: Int {
    case empty = 0, manySeats, fewSeats, standingRoomOnly, crushedStandingRoomOnly, full, notAcceptingPassengers
}
