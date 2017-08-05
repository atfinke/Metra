//
//  MapFilter.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

struct MapFilter {

    private static let pathKey = "Path"

    static func shouldHide(routeID: String) -> Bool {
        return UserDefaults.standard.bool(forKey: routeID)
    }

    static func shouldHidePath() -> Bool {
        return UserDefaults.standard.bool(forKey: pathKey)
    }

    static func toggle(routeID: String, hide: Bool) {
        UserDefaults.standard.set(hide, forKey: routeID)
    }

    static func togglePath(hide: Bool) {
        UserDefaults.standard.set(hide, forKey: pathKey)
    }
}
