//
//  VehicleDescriptor.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

/// Identification information for the vehicle performing the trip.
public struct TSTRTVehicleDescriptor {

    /**
     Internal system identification of the vehicle. Should be unique per vehicle, and is used for tracking the vehicle as it proceeds through the system. This id should not be made visible to the end-user; for that purpose use the label field
     */
    public let id: String?

    /**
     User visible label, i.e., something that must be shown to the passenger to help identify the correct vehicle.
     */
    public let label: String?

    /// The license plate of the vehicle.
    public let licensePlate: String?
}
