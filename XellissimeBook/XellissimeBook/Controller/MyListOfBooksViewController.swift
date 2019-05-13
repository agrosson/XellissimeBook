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
    
    @IBOutlet weak var mycol: UICollectionView!
    var bookA = Book(title: "le livre", author: "l'auteur", isbn: "l'isbn")
    // MARK: - Properties
    var collectionBooks = [Book]()
    var collectionOfImageBooks = [UIImage]()
    let imageDefault1 = UIImage.init(named: "notebook")
    var imagefromFire : UIImage?
    
    var ref: DatabaseReference?
    var databaseHandler : DatabaseHandle?
    // reference for cover images in Firebase Storage
    var coverReference: StorageReference {
        return Storage.storage().reference().child("cover")
    }
    var tempCoverReferenceWhenUploadOrDownLoad = StorageReference()
    var tempCoverURLString = ""
    var keysForBooks = [String]()
    
    // MARK: - Outlet
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reference to the database
        ref = Database.database().reference()
        // Retrieve the books and listen for change

            self.databaseHandler = self.ref?.child("books").observe(.value, with: { (snapshot) in
              //  print("on est là?")
                // reference de book
             //   print(snapshot.key)
                var counter = 1
                for mychild in snapshot.children {
                    print("Détail du livre \(counter)")
                    counter += 1
                    let childTest = mychild as! DataSnapshot
                //    print(childTest.key)
                    //        let childKey = childTest.key
                //    print("nouvel essai")
                 //   print(childTest.value as Any)
                    let values = childTest.value as! [String : AnyObject]
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
                    
                    var bookFromFireBase = Book(title: bookTitle, author: bookAuthor, isbn: bookIsbn)
                    bookFromFireBase.bookId = bookId
                    bookCoverURL.removeFirstAndLastAndDoubleWhitespace()
                    bookFromFireBase.bookCoverURL = bookCoverURL
                    bookFromFireBase.bookEditor = bookEditor
                    bookFromFireBase.bookIsAvailable = bookIsAvailable
                    bookFromFireBase.bookOwner = bookOwner
                    bookFromFireBase.bookTypeString = bookTypeString
                    bookFromFireBase.bookYearOfEdition = bookYearOfEdition
                    // I store the image if any
//self.storeCoverImageInFirebaseStorage(fromBook: bookFromFireBase)
                    self.collectionBooks.append(bookFromFireBase)
                    self.mycol.reloadData()
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

                    
                }
            })
    }
    
    private func storeCoverImageInFirebaseStorage(fromBook : Book) {
        tempCoverURLString = ""
        // get url string from book
        guard let bookUrl = fromBook.bookCoverURL else {return}
        // get url from url string
        guard let url = URL(string: bookUrl) else {return}
        // get data from url
        guard let data = try? Data(contentsOf: url) else {return}
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        guard let dataasImage = UIImage(data: data) else {return}
        guard let imageData = dataasImage.jpegData(compressionQuality: 1) else {return}
        tempCoverReferenceWhenUploadOrDownLoad = coverReference.child(fromBook.bookId)
        let uploadTask = tempCoverReferenceWhenUploadOrDownLoad.putData(imageData, metadata: nil) { (metadata, erro) in
            print("upload is finished")
            print(metadata ?? "no metadata")
            print(erro ?? "no error")
            // To do get the reference as a string : tempCoverURLString =
        }
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "No More Progress")
        }
        uploadTask.resume()
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
            
            var imageToGet : UIImage?
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
                }
            } else {
                imageViewBook.image = imageDefault1!
            }
        }
        return cell
        
    }
}
