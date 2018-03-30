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

    // swiftlint:disable identifier_name
    let id: String
    let name: String
    let color: UIColor

    // MARK: - Initialization

    static func loadFromCSV() -> [Route] {
        let path = Bundle.main.path(forResource: "routes", ofType: "txt")!
        let stream = InputStream(fileAtPath: path)!
        guard let csv = try? CSV(stream: stream) else {
            fatalError()
        }
        _ = csv.next()

        var routes = [Route]()
        while let row = csv.next() {
            var colorString = row[6]
            colorString.remove(at: colorString.startIndex)
            guard let color = UIColor(hexString: String(colorString)) else {
                fatalError()
            }
            routes.append(Route(id: row[0], name: row[1].replacingOccurrences(of: " ", with: ""), color: color))
        }

        return routes.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        })
    }

}
