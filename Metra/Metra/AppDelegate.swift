//
//  AppDelegate.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let url = Bundle.main.url(forResource: "fabric.apikey", withExtension: nil),
            let key = try? String(contentsOf: url) else {
                fatalError()
        }
        Crashlytics.start(withAPIKey: key.replacingOccurrences(of: "\n", with: ""))

        System.shared.start()

        let metraColor = UIColor(red: 11.0/255.0, green: 86.0/255.0, blue: 162.0/255.0, alpha: 1.0)

        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barTintColor = metraColor

        UITabBarItem.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.white
            ], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            ], for: .normal)

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = metraColor

        guard let tabBarController = window?.rootViewController as? UITabBarController else {
            fatalError()
        }

        tabBarController.tabBar.items?[0].selectedImage = #imageLiteral(resourceName: "MapFilled")
        tabBarController.tabBar.items?[0].image = #imageLiteral(resourceName: "MapEmpty").withRenderingMode(.alwaysOriginal)
        tabBarController.tabBar.items?[1].selectedImage = #imageLiteral(resourceName: "AlertFilled")
        tabBarController.tabBar.items?[1].image = #imageLiteral(resourceName: "AlertEmpty").withRenderingMode(.alwaysOriginal)

        return true
    }

}
