//
//  Cause.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/// Cause of this alert.
public enum TSTRTCause: Int {
    case unknown = 0, other, technicalProblem, strike, demonstration, accident
    case holiday, weather, maintenance, construction, policeActivity, medicalEmergency
}
