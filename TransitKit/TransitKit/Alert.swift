//
//  Alert.swift
//  TransitKit
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
/// An alert, indicating some sort of incident in the public transit network.
public struct TSTRTAlert {
    /**
     Time when the alert should be shown to the user. If missing, the alert will be shown as long as it appears in the feed. If multiple ranges are given, the alert will be shown during all of them.
     */
    public let activePeriods: [TSTRTTimeRange]

    /**
     Entities whose users we should notify of this alert.
     */
    public let informedEntities: [TSTRTEntitySelector]

    public let cause: TSTRTCause?
    public let effect: TSTRTEffect?

    /// The URL which provides additional information about the alert.
    public let urlString: String?
    /// Header for the alert. This plain-text string will be highlighted, for example in boldface.
    public let headerText: String?
    /**
     Description for the alert. This plain-text string will be formatted as the body of the alert (or shown on an explicit "expand" request by the user). The information in the description should add to the information of the header.
     */
    public let descriptionText: String?
}
