//
//  System.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import CSV
import UIKit

struct System {

    static let shared = System()

    var routes = Route.loadFromCSV()
    var shapes = Shape.loadFromCSV()

    func start() {}

    func color(for route: String?) -> UIColor? {
        return routes.filter({ $0.id == route}).first?.color
    }

}
