//
//  AppDelegate.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Foundation
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?)
                    -> Bool {
        // Configue FireBase for the Application
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
