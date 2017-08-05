//
//  TimeRange.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/// A time interval. The interval is considered active at time t if t is greater than or equal to the start time and less than the end time.
public struct TSTRTTimeRange {

    /**
     Start time, in POSIX time (i.e., number of seconds since January 1st 1970 00:00:00 UTC). If missing, the interval starts at minus infinity.
     */
    public let start: Date?

    /**
     End time, in POSIX time (i.e., number of seconds since January 1st 1970 00:00:00 UTC). If missing, the interval ends at plus infinity.
     */
    public let end: Date?
}
