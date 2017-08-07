//
//  AlertTableViewController.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit
import TransitKit

// swiftlint:disable line_length
class AlertsTableViewController: UITableViewController {

    // MARK: - Types

    enum SortedInformedEntity: Int {
        case agency = 0
        case trip, stop, route, other

        init(entity: TSTRTEntitySelector) {
            switch entity {
            case .agencyID:
                self = .agency
            case .routeID:
                self = .route
            case .routeType:
                self = .other
            case .stopID:
                self = .stop
            case .trip:
                self = .trip
            }
        }

        var title: String {
            switch self {
            case .agency: return "System Alerts"
            case .route: return "Route Alerts"
            case .trip: return "Train Alerts"
            case .stop: return "Stop Alerts"
            case .other: return "Other Alerts"
            }
        }

        static var all: [SortedInformedEntity] = [.agency, .route, .trip, .stop, .other]
    }

    // MARK: - Properties

    private var alerts = [SortedInformedEntity: [String]]()
    private var sortedSections: [SortedInformedEntity] {
        return alerts.keys.sorted(by: { (lhs, rhs) -> Bool in
            lhs.rawValue < rhs.rawValue
        })
    }

    private var reloadBarButtonItem: UIBarButtonItem?
    private let loadingBarButtonItem: UIBarButtonItem = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.sizeToFit()
        activityView.startAnimating()
        return UIBarButtonItem(customView: activityView)
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadBarButtonItem = navigationItem.rightBarButtonItem

        tableView.estimatedRowHeight = 70
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAlerts()
    }

    // MARK: - Fetching Alerts

    @IBAction func fetchAlerts() {
        navigationItem.rightBarButtonItem = loadingBarButtonItem

        MetraDownloadTask.fetch(feed: .alerts) { (entities) in
            for entity in SortedInformedEntity.all {
                self.alerts[entity] = []
            }
            for entity in entities ?? [] {
                if let alert = entity.alert,
                    let title = alert.headerText,
                    let transitInformedEntitity = alert.informedEntities.first {
                    var bridged = title as NSString
                    let range = bridged.range(of: " - ")
                    if range.location != NSNotFound {
                        bridged = bridged.substring(from: range.location + 3) as NSString
                    }
                    self.alerts[SortedInformedEntity(entity: transitInformedEntitity)]!.append(bridged as String)
                }
            }
            for entity in SortedInformedEntity.all {
                let alerts = self.alerts[entity]
                if alerts?.count == 0 {
                    self.alerts[entity] = nil
                } else {
                    self.alerts[entity]  = self.alerts[entity]?.sorted()
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem = self.reloadBarButtonItem

                if entities == nil {
                    let alertController = UIAlertController(title: "Connection Issue",
                                                            message: "There was an issue connecting to Metra's servers.",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.alerts.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts[sortedSections[section]]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.reuseIdentifier, for: indexPath) as? AlertTableViewCell,
            let alert = alerts[sortedSections[indexPath.section]]?[indexPath.row] else {
                fatalError()
        }
        cell.titleLabel.text = alert
        return cell
    }

}
