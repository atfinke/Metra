//
//  MetraDownloadTask.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation
import TransitKit

struct MetraDownloadTask {

    enum Feed: String {
        case alerts, positions, tripUpdates
    }

    private static let authorizationFieldValue: String = {
        let loginString = "0e2cd0794f015b0ab15b97855f5e2fc1:889203f703127efb79a80727dcf56e5d"
        guard let loginData = loginString .data(using: .utf8) else {
            fatalError()
        }
        let base64LoginString = loginData.base64EncodedString()
        return "Basic \(base64LoginString)"
    }()

    // MARK: - Requests

    private static let alertsRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://gtfsapi.metrarail.com/gtfs/alerts")!)
        request.setValue(authorizationFieldValue, forHTTPHeaderField: "Authorization")
        return request
    }()

    private static let positionRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://gtfsapi.metrarail.com/gtfs/positions")!)
        request.setValue(authorizationFieldValue, forHTTPHeaderField: "Authorization")
        return request
    }()

    private static let tripUpdatesRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://gtfsapi.metrarail.com/gtfs/tripUpdates")!)
        request.setValue(authorizationFieldValue, forHTTPHeaderField: "Authorization")
        return request
    }()

    // MARK: - Fetching

    static func fetch(feed: Feed, completion: @escaping ([TSTRTFeedEntity]?) -> ()) {
        let request: URLRequest

        switch feed {
        case .alerts:
            request = alertsRequest
        case .positions:
            request = positionRequest
        case .tripUpdates:
            request = tripUpdatesRequest
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, let entites = TSTRTMetraParser.parse(data: data).entities {
                completion(entites)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
