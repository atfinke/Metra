//
//  MapViewController+Filter.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

#if os(iOS)
extension MapViewController: UIPopoverPresentationControllerDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? FilterTableViewController else {
            fatalError()
        }

        destination.preferredContentSize = CGSize(width: 200, height: 530)
        destination.popoverPresentationController?.delegate = self
        destination.updatedFilters = {
            self.updateFiltering()
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
#endif
