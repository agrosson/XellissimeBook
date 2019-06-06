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
import FirebaseStorage
import FirebaseDatabase


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
func getErrorMessageFromFireBase(error: String) -> String? {
    var counter = 0
    /// var that tracks the first " - beginning of the text message
    var start = 0
    /// var that tracks the last " - end of the text message
    var end = 0
    var counterQuote = 0
    for char in error where char == "\u{22}" {
        counterQuote += 1
    }
    if counterQuote != 2 {
        return nil
    }
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
    return String(myWarning)
}

// MARK: - Methods

/**
 Function that stores cover information from a bbok
 - Parameter fromBook: the book to save
 */
 func storeCoverImageInFirebaseStorage(fromBook: Book) {
    // get url string from book
    guard let bookUrl = fromBook.bookCoverURL else {return}
    // get url from url string
    guard let url = URL(string: bookUrl) else {return}
    // get data from url
    guard let data = try? Data(contentsOf: url) else {return}
    // create a UIImage from the data
    guard let dataasImage = UIImage(data: data) else {return}
    // create an data in jpg format from a UIImage
    guard let imageData = dataasImage.jpegData(compressionQuality: 1) else {return}
    // Create a Storage reference with the bookId
    let storageRef = Storage.storage().reference(withPath: "cover/\(fromBook.bookIsbn).jpg")
    
    let uploadMetadata = StorageMetadata()
    // Describe the type of image stored in FireStorage
    uploadMetadata.contentType = "image/jpeg"
    
    let uploadTask = storageRef.putData(imageData, metadata: uploadMetadata) { (metadata, errorUpLoad) in
         DispatchQueue.main.async {
        if errorUpLoad != nil {
            print("i received an error \(errorUpLoad?.localizedDescription ?? "error but no description")")
        } else {
            print("upload is finished")
          print("Here are some metadata \(String(describing: metadata))")
            if metadata == nil {
                print("oups")
            }else {
                 print("metadata existe")
                let stor = metadata?.storageReference
                print("la descritpion du stor \(String(describing: stor))")
                let stro = uploadMetadata.storageReference
                 print("la descritpion du stor \(String(describing: stro))")
                 print("la descritpion du stor \(String(describing: storageRef))")
            }
        }
        }
    }
    uploadTask.observe(.progress) { (snapshot) in
        guard let progress = snapshot.progress else {return}
        print(progress)
        uploadTask.resume()
        print("Test print to see if download is done")
    }
    
}
 

/**
 Function that stores cover information from a picture taken from device
 - Parameter fromBook: the book to save
 
func storeCoverImageInFirebaseStorageFromDevice(imageToSave: UIImage, toBook : Book) -> String {

    let dataasImage = imageToSave
    // create an data in jpg format from a UIImage
    guard let imageData = dataasImage.jpegData(compressionQuality: 1) else {return ""}
    // Create a Storage reference with the bookId
    let storageRef = Storage.storage().reference().child("cover").child("\(toBook.bookIsbn).jpg")
    let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, errorUpLoad) in
        print(metadata ?? "no metadata")
        print(errorUpLoad ?? "no error")
        storageRef.downloadURL(completion: { (url, error) in
            //    self.tempURL = url
            print("toutou")
            print(url as Any)
        })
    }
    uploadTask.observe(.progress) { (snapshot) in
        print(snapshot.progress ?? "No More Progress")
    }
    uploadTask.resume()
    print("Text printed if download is done")
    storageRef.downloadURL(completion: { (url, error) in
        //   self.tempURL = url
        print(url as Any)
    })
    
    return "à définir"
}
*/
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
