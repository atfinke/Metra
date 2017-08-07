//
//  ViewController.swift
//  Metra (tvOS)
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let mapViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {
            fatalError()
        }
        addChildViewController(mapViewController)

        let mapView = mapViewController.view!
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        mapViewController.didMove(toParentViewController: self)
    }

}
