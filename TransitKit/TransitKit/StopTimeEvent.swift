//
//  StopTimeEvent.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/**
 Timing information for a single predicted event (either arrival or departure). Timing consists of delay and/or estimated time, and uncertainty.

 delay should be used when the prediction is given relative to some existing schedule in GTFS.
 time should be given whether there is a predicted schedule or not. If both time and delay are specified, time will take precedence (although normally, time, if given for a scheduled trip, should be equal to scheduled time in GTFS + delay).
 Uncertainty applies equally to both time and delay. The uncertainty roughly specifies the expected error in true delay (but note, we don't yet define its precise statistical meaning). It's possible for the uncertainty to be 0, for example for trains that are driven under computer timing control.
 */
public struct TSTRTStopTimeEvent {

    /**
     Delay (in seconds) can be positive (meaning that the vehicle is late) or negative (meaning that the vehicle is ahead of schedule). Delay of 0 means that the vehicle is exactly on time.
     */
    public let delay: Int?

    /**
     Event as absolute time. In POSIX time (i.e., number of seconds since January 1st 1970 00:00:00 UTC).
     */
    public let time: Date?

    /**
     If uncertainty is omitted, it is interpreted as unknown. To specify a completely certain prediction, set its uncertainty to 0.
     */
    public let uncertainty: Int?
}
