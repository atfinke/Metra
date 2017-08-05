//
//  EntitySelector.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

public enum TSTRTEntitySelector {
    case agencyID(String)
    case routeID(String)
    case routeType(Int)
    case trip(TSTRTTripDescriptor)
    case stopID(String)
}
