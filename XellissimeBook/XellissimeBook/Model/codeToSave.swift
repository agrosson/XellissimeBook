//
//  codeToSave.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 07/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

/*
 code from func storeCoverImageInFirebaseStorage(fromBook: Book)
 
     let uploadTask = storageRef.putData(imageData, metadata: uploadMetadata) { (metadata, errorUpLoad) in
          DispatchQueue.main.async {
              print("serie de test 6")
         if errorUpLoad != nil {
             print("i received an error \(errorUpLoad?.localizedDescription ?? "error but no description")")
         } else {
             print("upload is finished")
             if metadata == nil {
                 print("No metada")
             }else {
                 print("Here are some metadata \(String(describing: metadata))")
                 let storageMetadata = metadata?.storageReference
                 print("Here are the storageMetadata \(String(describing: storageMetadata))")
                 let uploadStorageReference = uploadMetadata.storageReference
                  print("Here are the uploadStorageReference \(String(describing: uploadStorageReference))")
                  print("Here are the initial storageRef \(String(describing: storageRef))")
             }
         }
         }
     }
  Observer of the uploadTask : describe the progression of the upLoad
     uploadTask.observe(.progress) { (snapshot) in
          print("serie de test a")
         guard let progress = snapshot.progress else {return}
         print(progress)
         print("serie de test B")
         uploadTask.resume()
         print("Test print to see if download is done")
     }
 */

/*
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
 */
