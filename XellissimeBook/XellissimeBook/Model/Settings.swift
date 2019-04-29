//
//  Settings.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 29/04/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


class SettingsService {
    private struct Keys {
        static let hasBeenAlreadyConnected = "hasBeenAlreadyConnected"
    }
    static var hasBeenAlreadyConnected: Bool {
        get {
            // if first connection, no default value is false
            return  UserDefaults.standard.bool(forKey: Keys.hasBeenAlreadyConnected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasBeenAlreadyConnected)
        }
    }
    
}
