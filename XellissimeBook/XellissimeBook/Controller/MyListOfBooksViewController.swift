//
//  MyListOfBooksViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 06/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage



class MyListOfBooksViewController: UIViewController {
    
    var optionToList = 2
    // MARK: - Outlet - CollectionView
    @IBOutlet weak var mycol: UICollectionView!
    
    // MARK: - Properties
    /// Empty book for testing
    var bookA = Book(title: "le livre", author: "l'auteur", isbn: "l'isbn")
    /// Array of books : displayed in collectionView
    var collectionBooks = [Book]()
    /// Array of book covers images : displayed in collectionView
    var collectionOfImageBooks = [UIImage]()
    /// Default image for cover book : used when no book cover is found
    let imageDefault1 = UIImage.init(named: "notebook")
    /// Image Object to store image received from FirebaseStorage
    var imagefromFire : UIImage?
    /// Firebase reference
    var ref: DatabaseReference?
    /// Firebase var is used to identify listeners of Firebase Database events
    var databaseHandler : DatabaseHandle?
    /// Firebase reference for cover images in Firebase Storage
    var coverReference: StorageReference = Storage.storage().reference().child("cover")

    /// Temp reference of a Google Cloud Storage object
    var tempCoverReferenceWhenUploadOrDownLoad = StorageReference()
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reference to the database
        ref = Database.database().reference()
        // Retrieve the books and listen for change
        self.databaseHandler = self.ref?.child("books").observe(.value, with: { (snapshot) in
            var counter = 1
            // In repo "books", go to every "child"
            for mychild in snapshot.children {
                print("Détail du livre \(counter)")
                counter += 1
                /// A FIRDataSnapshot contains data from a Firebase Database location
                let childTest = mychild as! DataSnapshot
                // the data contained in the DataSnapshot is a dictionary of type [String : AnyObject]
                let values = childTest.value as! [String : AnyObject]
                // Get all values from Dictionary
                guard   let bookId: String = values["bookId"] as? String,
                    let bookIsbn: String = values["bookIsbn"] as? String,
                    let bookAuthor: String = values["bookAuthor"] as? String,
                    var bookCoverURL: String = values["bookCover"] as? String,
                    let bookEditor: String = values["bookEditor"] as? String,
                    let bookIsAvailable: Bool = values["bookIsAvailable"] as? Bool,
                    let bookOwner: String = values["bookIsbn"] as? String,
                    let bookTitle: String = values["bookTitle"] as? String,
                    let bookTypeString: String = values["bookType"] as? String,
                    let bookYearOfEdition: String = values["bookYearOfEdition"] as? String
                    else {return}
                // Use the values to create a book
                var bookFromFireBase = Book(title: bookTitle, author: bookAuthor, isbn: bookIsbn)
                bookFromFireBase.bookId = bookId
                bookCoverURL.removeFirstAndLastAndDoubleWhitespace()
                // To do here : change the url if needed
                bookFromFireBase.bookCoverURL = bookCoverURL
                bookFromFireBase.bookEditor = bookEditor
                bookFromFireBase.bookIsAvailable = bookIsAvailable
                bookFromFireBase.bookOwner = bookOwner
                bookFromFireBase.bookTypeString = bookTypeString
                bookFromFireBase.bookYearOfEdition = bookYearOfEdition
                // Add the book in the collectionBook
                self.collectionBooks.append(bookFromFireBase)
                // reload the collectionView
                self.mycol.reloadData()
                /* Check the data with a print if needed
                 //                    print("ceci pour la référence dans firebase : \(childKey)")
                 //                    print("bookId is dans xcode : \(String(describing: bookId))")
                 //                    print("bookAuthor is : \(String(describing: bookAuthor))")
                 //                    print("bookCoverURL is : \(String(describing: bookCoverURL))")
                 //                    print("bookIsbn is : \(String(describing: bookIsbn))")
                 //                    print("bookEditor is : \(String(describing: bookEditor))")
                 //                    print("bookIsAvailable is : \(String(describing: bookIsAvailable))")
                 //                    print("bookOwner is \(String(describing: bookOwner))")
                 //                    print("bookYearOfEdition is \(String(describing: bookYearOfEdition))")
                 //                    print("bookTitle is \(String(describing: bookTitle))")
                 //                    print("bookType is \(String(describing: bookTypeString))")
                 */
            }
        })
    }
    
    private func storeCoverImageInFirebaseStorage(fromBook : Book) {
        // get url string from book
        guard let bookUrl = fromBook.bookCoverURL else {return}
        // get url from url string
        guard let url = URL(string: bookUrl) else {return}
        // get data from url
        guard let data = try? Data(contentsOf: url) else {return}
        // create a UIImage from the data
        guard let dataasImage = UIImage(data: data) else {return}
        // create an data in jpg format from a UIImage
        
        
        guard let imageData = dataasImage.pngData() else {return}
//
//        dataasImage
//        jpegData(compressionQuality: 1) else {return}
        
        // Create a Storage reference with the bookId
        
        //let fileNameStorage = fromBook.bookIsbn
        tempCoverReferenceWhenUploadOrDownLoad = Storage.storage().reference(forURL: "gs://xellissimebook.appspot.com/cover/"+"\(fromBook.bookIsbn).jpg")
        

        // create a tast to put (send) the data in the Firebase storage at storage reference
        let uploadTask = tempCoverReferenceWhenUploadOrDownLoad.putData(imageData, metadata: nil) { (metadata, erro) in
            print("upload is finished")
            print(metadata ?? "no metadata")
            print(erro ?? "no error")
        }
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "No More Progress")
        }
        uploadTask.resume()
        print("Test print to see if download is done")
    }
    
    
    
    private func downloadImage(urlString : String) {
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.imagefromFire = UIImage(data: data!)
    }
}

extension MyListOfBooksViewController: UICollectionViewDelegate {
    
}

extension MyListOfBooksViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of item in the data source array
        return collectionBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create the cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: TextAndString.shared.myListOfBookCell, for: indexPath)
        if let labelTitle = cell.viewWithTag(100) as?  UILabel {
            labelTitle.text = collectionBooks[indexPath.row].bookTitle
        }
        if let labelAuthor = cell.viewWithTag(101) as?  UILabel {
            labelAuthor.text = collectionBooks[indexPath.row].bookAuthor
        }
        if let labelEditor = cell.viewWithTag(102) as?  UILabel {
            labelEditor.text = collectionBooks[indexPath.row].bookEditor
        }
        if let imageViewBook = cell.viewWithTag(199) as? UIImageView {
            
            if optionToList == 1 {
                let coverurl = "\(String(describing: collectionBooks[indexPath.row].bookCoverURL!))"
                print("coever url \(coverurl)")
                let filename =  "\(collectionBooks[indexPath.row].bookIsbn)"
                print("filename")
                print(filename)
                
                let ref = coverReference.child(filename)
                print("la ref \(ref)")
                
                print("mon temp \(tempCoverReferenceWhenUploadOrDownLoad)")
                
                let leString = "gs://xellissimebook.appspot.com/cover/"+"\(filename).jpg"
                let leString2 = "https://firebasestorage.googleapis.com/v0/b/xellissimebook.appspot.com/o/cover/2F9782070412396.jpg?alt=media&token=bd6d7523-4a5f-4a7a-a9f5-9c1fa01fdff1"
                 print("le string \(leString)")
                
                let downloadImageRef = Storage.storage().reference(forURL: leString)
                let dwn = downloadImageRef.getData(maxSize: 55555555) { (data, error) in
                  

                    
                    if error != nil {
                        print("baaaaddd")
                        // Uh-oh, an error occurred!
                    } else {
                        print("gooooooood")
                        // Data for "images/island.jpg" is returned
                        imageViewBook.image = UIImage(data: data!)
                        
                    }
                }
              dwn.resume()
                        
                        /*                if let error = error {
                            print(error )
                        }
                        if let data = data {
                            print("17 mai")
                            let image = UIImage(data: data)
                            imageViewBook.image = image
                        }
                        print(error ?? "NO ERROR")
                    */
                        
                
//                    downloadtask.observe(.progress) { (snapshot) in
//                        print(snapshot.progress ?? "NO MORE PROGRESS")
//                    }
                
                
                    
                    print("j'en ai trouvé")
                
            }
            if optionToList == 2 {
                if var urlTest = collectionBooks[indexPath.row].bookCoverURL {
                    var imageToGet: UIImage?
                    print("ceci est l'url :\(urlTest)")
                    urlTest.removeFirstAndLastAndDoubleWhitespace()
                    if let url = URL(string: urlTest) {
                        let data = try? Data(contentsOf: url)
                        if let datatNotNil = data {
                            imageToGet = UIImage(data: datatNotNil)
                            let size = CGSize(width: 100, height: 100)
                            let resizedImage = resizeImage(image: imageToGet!, targetSize: size)
                            imageViewBook.image = resizedImage
                        }
                        else {
                            imageViewBook.image = imageDefault1!
                        }
                    }
                    else {
                        imageViewBook.image = imageDefault1!
                        
                    }
                }
                else {
                    imageViewBook.image = imageDefault1!
                }
                
                
            }
            
//
//            let downloadImageRef = coverReference.child(filename)
//
//            let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
//                if let data = data {
//                    let image = UIImage(data: data)
//                    imageViewBook.image = image
//                }
//                print(error ?? "NO ERROR")
//            }
//
//            downloadtask.observe(.progress) { (snapshot) in
//                print(snapshot.progress ?? "NO MORE PROGRESS")
//            }
//
//            downloadtask.resume()
//
//
//        }
            
            return cell
        }
        return cell
    }
}
/*
 if var urlTest = collectionBooks[indexPath.row].bookCoverURL {
 print("ceci est l'url :\(urlTest)")
 urlTest.removeFirstAndLastAndDoubleWhitespace()
 if let url = URL(string: urlTest) {
 let data = try? Data(contentsOf: url)
 if let datatNotNil = data {
 imageToGet = UIImage(data: datatNotNil)
 let size = CGSize(width: 100, height: 100)
 let resizedImage = resizeImage(image: imageToGet!, targetSize: size)
 imageViewBook.image = resizedImage
 }
 else {
 imageViewBook.image = imageDefault1!
 }
 }
 else {
 imageViewBook.image = imageDefault1!
 
 }
 }
 else {
 imageViewBook.image = imageDefault1!
 }
 }*/


/*
 let task = referenceCover.getData(maxSize: 1024*1024*12) { (data, error) in
 
 if let data = data {
 let imageToGet = UIImage(data: data)
 imageViewBook.image = imageToGet
 }
 
 else {
 imageViewBook.image = self.imageDefault1!
 }
 print(error ?? "no error here")
 }
 
 
 task.resume()
 */
