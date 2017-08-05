//
//  CongestionLevel.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/// Congestion level that is affecting this vehicle.
public enum TSTRTCongestionLevel: Int {
    case unknown = 0, runningSmoothly, stopAndGo, congestion, severeCongestion
}
