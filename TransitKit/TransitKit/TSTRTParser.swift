//
//  TSTRTParser.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

public protocol TSTRTParser {
    static func parse(data: Data) -> (entities: [TSTRTFeedEntity]?, error: TSTRTParserError?)
}

public enum TSTRTParserError: Error {
    case json, jsonCast
}

// swiftlint:disable identifier_name
enum TSTRTParserKey: String {
    case trip_update, alert, vehicle, id
    case current_status, position, timestamp, trip
    case latitude, longitude
    case low
    case route_id, schedule_relationship, start_date, start_time, trip_id
    case label
    case stop_time_update
    case arrival, departure, stop_id, stop_sequence
    case delay, time, uncertainty
    case active_period, cause, description_text, effect, header_text, informed_entity, url
    case start, end
    case translation, language, text
    case agency_id, route_type
}

extension Dictionary where Key == String {
    subscript(parserKey: TSTRTParserKey) -> Value? {
        get {
            return self[parserKey.rawValue]
        }
        set {
            self[parserKey.rawValue] = newValue
        }
    }
}
