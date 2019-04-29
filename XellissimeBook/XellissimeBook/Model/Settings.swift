//
//  Settings.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Global variables

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width

// MARK: - Settings class
/**
 This class enables to set UserDefault
 */
class SettingsService {
    // MARK: - Structs for UserDefault keys
    private struct Keys {
        static let hasBeenAlreadyConnected = "hasBeenAlreadyConnected"
        static let hasAcceptedConditions = "hasAcceptedConditions"
    }
    // MARK: - Properties
    ///
    static var hasBeenAlreadyConnected: Bool {
        get {
            // if first connection, no default value is false
            return  UserDefaults.standard.bool(forKey: Keys.hasBeenAlreadyConnected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasBeenAlreadyConnected)
        }
    }
    static var hasAcceptedConditions: Bool {
        get {
            // if first connection, no default value is false
            return  UserDefaults.standard.bool(forKey: Keys.hasAcceptedConditions)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasAcceptedConditions)
        }
    }
}
