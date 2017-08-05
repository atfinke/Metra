//
//  TSTRTMetraParser.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

public struct TSTRTMetraParser: TSTRTParser {

    private static let timestampDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.'000Z'"
        return formatter
    }()

    public static func parse(data: Data) -> (entities: [TSTRTFeedEntity]?, error: TSTRTParserError?) {
        let jsonObject: Any

        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            return (nil, .json)
        }

        guard let jsonArray = jsonObject as? [[String: Any]] else { return (nil, .jsonCast) }

        var entities = [TSTRTFeedEntity]()
        for entityObject in jsonArray {
            entities.append(parse(entityObject: entityObject))
        }

        return (entities, nil)
    }

    private static func parse(entityObject: [String: Any]) -> TSTRTFeedEntity {
        guard let id = entityObject[.id] as? String else { fatalError() }

        var alert: TSTRTAlert?
        if let alertObject = entityObject[.alert] as? [String: Any] {
            alert = parse(alertObject: alertObject)
        }
        var tripUpdate: TSTRTTripUpdate?
        if let tripUpdateObject = entityObject[.trip_update] as? [String: Any] {
            tripUpdate = parse(tripUpdateObject: tripUpdateObject)
        }
        var vehiclePosition: TSTRTVehiclePosition?
        if let vehiclePositionObject = entityObject[.vehicle] as? [String: Any] {
            vehiclePosition = parse(vehiclePositionObject: vehiclePositionObject)
        }

        return TSTRTFeedEntity(id: id, tripUpdate: tripUpdate, vehiclePosition: vehiclePosition, alert: alert)
    }

    // MARK: - Parsing Individual Feed Entities

    private static func parse(alertObject: [String: Any]) -> TSTRTAlert? {
        guard let activePeriodsObject = alertObject[.active_period] as? [[String: [String: Any]]],
            let informedEntitiesObject = alertObject[.informed_entity] as? [[String: Any]] else {
                return nil
        }

        var activePeriods = [TSTRTTimeRange]()
        for periodObject in activePeriodsObject {
            var start: Date?
            if let startObject = periodObject[.start] {
                start = parse(timestampObject: startObject)
            }
            var end: Date?
            if let endObject = periodObject[.end] {
                end = parse(timestampObject: endObject)
            }
            activePeriods.append(TSTRTTimeRange(start: start, end: end))
        }
        var informedEntities = [TSTRTEntitySelector]()
        for entityObject in informedEntitiesObject {
            if let entity = parse(informedEntityObject: entityObject) {
                informedEntities.append(entity)
            }
        }
        var cause: TSTRTCause?
        if let causeObject = alertObject[.cause] as? Int {
            cause = TSTRTCause(rawValue: causeObject)
        }
        var effect: TSTRTEffect?
        if let effectObject = alertObject[.effect] as? Int {
            effect = TSTRTEffect(rawValue: effectObject)
        }
        var headerText: String?
        if let headerTextObject = alertObject[.header_text] as? [String: [[String: Any]]], let translationArray = headerTextObject[.translation], let englishTranslation = translationArray.filter({ $0[.language] as? String == "en-US" }).first {
            headerText = englishTranslation[.text] as? String
        }
        var descriptionText: String?
        if let descriptionTextObject = alertObject[.description_text] as? [String: [[String: Any]]], let translationArray = descriptionTextObject[.translation], let englishTranslation = translationArray.filter({ $0[.language] as? String == "en-US" }).first {
            descriptionText = englishTranslation[.text] as? String
        }

        return TSTRTAlert(activePeriods: activePeriods, informedEntities: informedEntities, cause: cause, effect: effect, urlString: nil, headerText: headerText, descriptionText: descriptionText)
    }

    private static func parse(tripUpdateObject: [String: Any]) -> TSTRTTripUpdate? {
        guard let stopTimeUpdatesObject = tripUpdateObject[.stop_time_update] as? [[String: Any]],
            let timestampDict = tripUpdateObject[.timestamp] as? [String: Any],
            let timestamp = parse(timestampObject: timestampDict),
            let tripObject = tripUpdateObject[.trip] as? [String: Any],
            let trip = parse(tripObject: tripObject) else {
                return nil
        }

        var vehicle: TSTRTVehicleDescriptor?
        if let vehicleObject = tripUpdateObject[.vehicle] as? [String: Any] {
            vehicle = parse(vehicleObject: vehicleObject)
        }
        var stopTimeUpdates = [TSTRTStopTimeUpdate]()
        for updateObject in stopTimeUpdatesObject {
            if let update = parse(stopTimeUpdateObject: updateObject) {
                stopTimeUpdates.append(update)
            }
        }

        let delay = tripUpdateObject[.delay] as? Int

        return TSTRTTripUpdate(trip: trip, vehicle: vehicle, stopTimeUpdates: stopTimeUpdates, date: timestamp, delay: delay)
    }

    private static func parse(vehiclePositionObject: [String: Any]) -> TSTRTVehiclePosition? {
        guard let currentStatusObject = vehiclePositionObject[.current_status] as? Int,
            let currentStatus = TSTRTVehicleStopStatus(rawValue: currentStatusObject),
            let timestampDict = vehiclePositionObject[.timestamp] as? [String: Any],
            let timestamp = parse(timestampObject: timestampDict) else {
                return nil
        }

        var trip: TSTRTTripDescriptor?
        if let tripObject = vehiclePositionObject[.trip] as? [String: Any] {
            trip = parse(tripObject: tripObject)
        }
        var vehicle: TSTRTVehicleDescriptor?
        if let vehicleObject = vehiclePositionObject[.vehicle] as? [String: Any] {
            vehicle = parse(vehicleObject: vehicleObject)
        }
        var position: TSTRTPosition?
        if let positionDict = vehiclePositionObject[.position] as? [String: Any],
            let latitude = positionDict[.latitude] as? Float,
            let longitude = positionDict[.longitude] as? Float {
            position = TSTRTPosition(latitude: latitude, longitude: longitude, bearing: nil, odometer: nil, speed: nil)
        }

        return TSTRTVehiclePosition(trip: trip, vehicle: vehicle, position: position, currentStopSequence: nil, stopID: nil, currentStatus: currentStatus, timestamp: timestamp, congestionLevel: nil, occupancyStatus: nil)
    }

    // MARK: - Parsing Shared Objects

    private static func parse(informedEntityObject: [String: Any]) -> TSTRTEntitySelector? {
        if let agencyID = informedEntityObject[.agency_id] as? String, agencyID != "<null>" {
            return .agencyID(agencyID)
        } else if let routeID = informedEntityObject[.route_id] as? String, routeID != "<null>" {
            return .routeID(routeID)
        } else if let routeType = informedEntityObject[.route_type] as? Int {
            return .routeType(routeType)
        } else if let stopID = informedEntityObject[.stop_id] as? String, stopID != "<null>" {
            return .stopID(stopID)
        } else if let tripObject = informedEntityObject[.trip] as? [String: Any], let trip = parse(tripObject: tripObject) {
            return .trip(trip)
        }
        return nil
    }

    private static func parse(positionObject: [String: Any]) -> TSTRTPosition? {
        guard let latitude = positionObject[.latitude] as? Float,
            let longitude = positionObject[.longitude] as? Float else {
                return nil
        }

        return TSTRTPosition(latitude: latitude, longitude: longitude, bearing: nil, odometer: nil, speed: nil)
    }

    private static func parse(stopTimeUpdateObject: [String: Any]) -> TSTRTStopTimeUpdate? {
        var arrival: TSTRTStopTimeEvent?
        if let arrivalObject = stopTimeUpdateObject[.arrival] as? [String: Any] {
            arrival = parse(stopTimeEventObject: arrivalObject)
        }
        var departure: TSTRTStopTimeEvent?
        if let departureObject = stopTimeUpdateObject[.departure] as? [String: Any] {
            departure = parse(stopTimeEventObject: departureObject)
        }
        var scheduleRelationship: TSTRTScheduleRelationship?
        if let scheduleRelationshipObject = stopTimeUpdateObject[.schedule_relationship] as? Int {
            scheduleRelationship = TSTRTScheduleRelationship(rawValue: scheduleRelationshipObject)
        }

        let stopID = stopTimeUpdateObject[.stop_id] as? String
        let stopSequence = stopTimeUpdateObject[.stop_sequence] as? Int

        return TSTRTStopTimeUpdate(stopSequence: stopSequence, stopID: stopID, arrival: arrival, departure: departure, scheduleRelationship: scheduleRelationship)
    }

    private static func parse(stopTimeEventObject: [String: Any]) -> TSTRTStopTimeEvent {
        var date: Date?
        if let timestampObject = stopTimeEventObject[.time] as? [String: Any] {
            date = parse(timestampObject: timestampObject)
        }

        let delay = stopTimeEventObject[.delay] as? Int
        let uncertainty = stopTimeEventObject[.uncertainty] as? Int

        return TSTRTStopTimeEvent(delay: delay, time: date, uncertainty: uncertainty)
    }

    private static func parse(timestampObject: [String: Any]) -> Date? {
        guard let timestampString = timestampObject[.low] as? String,
            let timestamp = TSTRTMetraParser.timestampDateFormatter.date(from: timestampString) else {
                return nil
        }
        return timestamp
    }

    private static func parse(tripObject: [String: Any]) -> TSTRTTripDescriptor? {
        guard let routeID = tripObject[.route_id] as? String,
            let tripID = tripObject[.trip_id] as? String else {
                return nil
        }

        var scheduleRelationship: TSTRTScheduleRelationship?
        if let scheduleRelationshipObject = tripObject[.schedule_relationship] as? Int {
            scheduleRelationship = TSTRTScheduleRelationship(rawValue: scheduleRelationshipObject)
        }

        let startDate = tripObject[.start_date] as? String
        let startTime = tripObject[.start_time] as? String

        return TSTRTTripDescriptor(tripID: tripID, routeID: routeID, directionID: nil, startTime: startTime, startDate: startDate, scheduleRelationship: scheduleRelationship)
    }

    private static func parse(vehicleObject: [String: Any]) -> TSTRTVehicleDescriptor? {
        guard let vehicleID = vehicleObject[.id] as? String,
            let vehicleLabel = vehicleObject[.label] as? String else {
                return nil
        }
        return TSTRTVehicleDescriptor(id: vehicleID, label: vehicleLabel, licensePlate: nil)
    }
}
