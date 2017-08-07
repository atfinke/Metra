//
//  Effect.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/// The effect of this problem on the affected entity.
public enum TSTRTEffect: Int {
    case noService = 0, reducedService, significantDelays, detour
    case additionalService, modifiedService, other, unknown, stopMoved
}
