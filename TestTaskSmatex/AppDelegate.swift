//
//  AppDelegate.swift
//  TestTaskSmatex
//
//  Created by Максим Шишканов on 20.07.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainViewController = ViewController()

        window = UIWindow()
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

