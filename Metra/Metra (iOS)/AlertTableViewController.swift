//
//  AlertTableViewController.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit
import SafariServices
import TransitKit

class AlertsTableViewController: UITableViewController, SFSafariViewControllerDelegate {

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

    private var alerts = [SortedInformedEntity: [TSTRTAlert]]()
    private var sortedSections: [SortedInformedEntity] {
        return alerts.keys.sorted(by: { (lhs, rhs) -> Bool in
            lhs.rawValue < rhs.rawValue
        })
    }

    private var reloadBarButtonItem: UIBarButtonItem?
    private let loadingBarButtonItem: UIBarButtonItem = {
        let activityView = UIActivityIndicatorView(style: .white)
        activityView.sizeToFit()
        activityView.startAnimating()
        return UIBarButtonItem(customView: activityView)
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }

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

        MetraDownloadTask.fetch(feed: .alerts) { entities in
            var newAlerts = [SortedInformedEntity: [TSTRTAlert]]()
            for entity in SortedInformedEntity.all {
                newAlerts[entity] = []
            }
            for entity in entities ?? [] {
                if let alert = entity.alert,
                    alert.headerText != nil,
                    let transitInformedEntity = alert.informedEntities.first {
                    newAlerts[SortedInformedEntity(entity: transitInformedEntity)]?.append(alert)
                }
            }
            for entity in SortedInformedEntity.all {
                let alerts = newAlerts[entity]
                if alerts?.count == 0 {
                    self.alerts[entity] = nil
                } else {
                    self.alerts[entity] = newAlerts[entity]?.sorted(by: { (lhs, rhs) -> Bool in
                        return lhs.headerText ?? "" < rhs.headerText ?? ""
                    })
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem = self.reloadBarButtonItem

                if entities == nil {
                    let message = "There was an issue connecting to Metra's servers."
                    let alertController = UIAlertController(title: "Connection Issue",
                                                            message: message,
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.alerts.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts[sortedSections[section]]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? AlertTableViewCell,
            let alert = alerts[sortedSections[indexPath.section]]?[indexPath.row],
            let alertTitle = alert.headerText else {
                fatalError()
        }

        var bridged = alertTitle as NSString
        let range = bridged.range(of: " - ")
        if range.location != NSNotFound {
            bridged = bridged.substring(from: range.location + 3) as NSString
        }

        cell.titleLabel.text = bridged as String

        let alertIncludesLink = alert.url != nil

        cell.isUserInteractionEnabled = alertIncludesLink
        cell.accessoryType = alertIncludesLink ? .disclosureIndicator : .none
        cell.layoutSubviews()

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = alerts[sortedSections[indexPath.section]]?[indexPath.row]
        guard let urlString = alert?.url, let url = URL(string: urlString) else {
            return
        }

        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = .metra
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

}
