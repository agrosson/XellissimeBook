//
//  Utilities.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

// MARK: - CustomTabBar class
/**
 This class enables to cutomize the tabBar height
 */
class CustomTabBar: UITabBar {
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

func getErrorMessageFromFireBase(error: String) -> String {
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

// MARK: - Methods
/**
 Function that saves the book in FireBase
 - Parameter book : book to be saved
 */
func saveBook(with book: Book) {
    // create a shortcut reference : type DataReference
    let databaseReference = Database.database().reference()
    // the book properties have to be saved as dictionary in Firebase
    let bookToSaveDictionary: [String : Any] =  ["bookId": book.bookId,
                                                 "bookIsbn": book.bookIsbn,
                                                 "bookTitle": book.bookTitle,
                                                 "bookAuthor": book.bookAuthor,
                                                 "bookEditor": book.bookEditor ?? "N/A",
                                                 "bookYearOfEdition": book.bookYearOfEdition ?? "N/A",
                                                 "bookCover": book.bookCoverURL ?? "",
                                                 "bookOwner": book.bookOwner,
                                                 "bookIsAvailable": book.bookIsAvailable,
                                                 //     "bookDateOfLoanStart" : book.bookDateOfLoanStart as Any,
        //    "bookDateOfLoanEnd": book.bookDateOfLoanEnd as Any,
        "bookType": book.bookTypeString ?? "unknown"]
    // In the dataBase, child is a repo, child userId (is an repo), create a dictionnary.
    // databaseReference.child("users").child(userId!).setValue(["bookId" : text])
    databaseReference.child("books").child(book.bookId).setValue(bookToSaveDictionary)
}
// MARK: - Methods
/**
 Function that resizes an image
 - Parameter image : the image to resize
 - Parameter targetSize : the new size
 - Returns: the image with the new size
 */
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    var newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height *  widthRatio)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
