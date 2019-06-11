//
//  Settings.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// credit
// Photo by Kourosh Qaffari on Unsplash

// MARK: - Global variables

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let popoverRoundRadius = CGFloat(30)
var scannedIsbn = ""
var comeFromAdd = false

// MARK: - Settings class
/**
 This class enables to set UserDefault
 */
class SettingsService {
    // MARK: - Structs for UserDefault keys
    private struct Keys {
        static let hasBeenAlreadyConnected = "hasBeenAlreadyConnected"
        static let hasAcceptedConditions = "hasAcceptedConditions"
        static let isAlreadyRegistered = "isAlreadyRegistered"
    }
    // MARK: - Properties
    /// Computed variable to check if first connection
    static var hasBeenAlreadyConnected: Bool {
        get {
            // if first connection, no default value is false
            return  UserDefaults.standard.bool(forKey: Keys.hasBeenAlreadyConnected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasBeenAlreadyConnected)
        }
    }
    /// Computed variable to check if first user conditions have been accepted
    static var hasAcceptedConditions: Bool {
        get {
            // if first connection, no default value is false
            return  UserDefaults.standard.bool(forKey: Keys.hasAcceptedConditions)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasAcceptedConditions)
        }
    }
    /// Computed variable to check if user conditions is already registered
    static var isAlreadyRegistered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isAlreadyRegistered)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isAlreadyRegistered)
        }
    }
}
