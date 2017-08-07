//
//  FilterTableViewController.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    // MARK: - Properties

    let reuseIdentifier = "reuseIdentifier"
    var updatedFilters: (() -> Void)?

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return System.shared.routes.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = System.shared.routes[indexPath.row].name
            let shouldHideRoute = MapFilter.shouldHide(routeID: System.shared.routes[indexPath.row].name)
            cell.accessoryType = shouldHideRoute ? .none : .checkmark
        } else {
            cell.textLabel?.text = "Show Paths"
            cell.accessoryType = MapFilter.shouldHidePath() ? .none : .checkmark
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Routes"
        } else {
            return "Options"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError()
        }

        let feedback = UISelectionFeedbackGenerator()
        feedback.prepare()

        let isHidden = cell.accessoryType == .none
        cell.accessoryType = isHidden ? .checkmark : .none

        if indexPath.section == 0 {
            MapFilter.toggle(routeID: System.shared.routes[indexPath.row].name, hide: !isHidden)
        } else {
            MapFilter.togglePath(hide: !isHidden)
        }

        feedback.selectionChanged()

        updatedFilters?()
    }
}
