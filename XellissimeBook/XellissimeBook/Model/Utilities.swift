//
//  Utilities.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - CustomTabBar class
/**
 This class enables to cutomize the tabBar height
 */
class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 65
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            
            if #available(iOS 11.0, *) {
                sizeThatFits.height = height + window.safeAreaInsets.bottom
            } else {
                sizeThatFits.height = height
            }
        }
        return sizeThatFits
    }
}
// MARK: - Methods
/**
 Function that extracts error text message from error received from Firebase after failing request
 - Parameter error : error message received from Firebase
 - Returns: explanation of error as a String
 */

func getErrorMessageFromFireBase(error : String) -> String {
    var counter = 0
    /// var that tracks the first " - beginning of the text message
    var start = 0
    /// var that tracks the last " - end of the text message
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
