//
//  ScheduleRelationship.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation


/// The relation between this StopTime and the static schedule.
///
/// - scheduled: The vehicle is proceeding in accordance with its static schedule of stops, although not necessarily according to the times of the schedule. This is the default behavior. At least one of arrival and departure must be provided. If the schedule for this stop contains both arrival and departure times then so must this update.
/// - skipped: The stop is skipped, i.e., the vehicle will not stop at this stop. Arrival and departure are optional.
/// - noData: No data is given for this stop. It indicates that there is no realtime information available. When set NO_DATA is propagated through subsequent stops so this is the recommended way of specifying from which stop you do not have realtime information. When NO_DATA is set neither arrival nor departure should be supplied.
public enum TSTRTScheduleRelationship: Int {
    case scheduled = 0, skipped, noData
}
