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
// MARK: - Global variables

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let popoverRoundRadius = CGFloat(30)

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

func getErrorMessageFromFireBase(error : String) -> String {
    var counter = 0
    var start = 0
    var end = 0
    for char in error {
        if char == "\u{22}" {
            if start == 0 {
                start = counter
                print("dans la boucle start \(counter)")
            }
            if end == 0 || end == start {
                end = counter
                print("dans la boucle end \(counter)")
            }
        }
        counter += 1
    }
    let sentenceStartIndex = error.index(error.startIndex, offsetBy: start+1)
    let sentenceEndIndex = error.index(error.startIndex, offsetBy: end)
    let myWarning = error[(sentenceStartIndex..<sentenceEndIndex)]
    print(myWarning)
    return String(myWarning)
}
