//
//  Route.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import CSV
import UIKit

struct Route {

    // MARK: - Properties

    let id: String
    let name: String
    let color: UIColor

    // MARK: - Initialization

    static func loadFromCSV() -> [Route] {
        let path = Bundle.main.path(forResource: "routes", ofType: "txt")!
        let stream = InputStream(fileAtPath: path)!
        let csv = try! CSV(stream: stream)
        let _ = csv.next()

        var routes = [Route]()
        while let row = csv.next() {
            var color = row[6]
            color.remove(at: color.startIndex)
            routes.append(Route(id: row[0], name: row[1].replacingOccurrences(of: " ", with: ""), color: UIColor(hexString: String(color))!))
        }

        return routes.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        })
    }
    
}
