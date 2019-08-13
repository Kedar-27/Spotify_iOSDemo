//
//  AppDelegate.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 12/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SpotifyHelper.shared.sessionManager.application(app, open: url, options: options)
        return true
    }


}

