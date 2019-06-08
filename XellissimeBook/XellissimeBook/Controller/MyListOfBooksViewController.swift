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
import Firebase
import FirebaseAuth



class MyListOfBooksViewController: UIViewController {

    var optionToList = 1
    // MARK: - Outlet - CollectionView
    @IBOutlet weak var mycol: UICollectionView!
    // MARK: - Properties
    /// StorageDownloadTask
    var download:StorageDownloadTask!
    /// Empty book for testing
    var bookA = Book(title: "le livre", author: "l'auteur", isbn: "l'isbn")
    /// Array of books : displayed in collectionView
    var collectionBooks = [Book]()
    /// Array of book covers images : displayed in collectionView
    var collectionOfImageBooks = [UIImage]()
    /// Default image for cover book : used when no book cover is found
    let imageDefault1 = UIImage.init(named: "notebook")
    /// Image Object to store image received from FirebaseStorage
    var imagefromFire: UIImage?
    /// Firebase reference
    var ref: DatabaseReference?
    /// Firebase var is used to identify listeners of Firebase Database events
    var databaseHandler: DatabaseHandle?
    /// Firebase reference for cover images in Firebase Storage
    var coverReference: StorageReference = Storage.storage().reference().child("cover")

    /// Temp reference of a Google Cloud Storage object
    var tempCoverReferenceWhenUploadOrDownLoad = StorageReference()
    // MARK: - ViewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
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
                guard let childTest = mychild as? DataSnapshot else {return}
                // the data contained in the DataSnapshot is a dictionary of type [String : AnyObject]
                guard let values = childTest.value as? [String: AnyObject] else {return}
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
            }
        })
    }
    // MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
     //   navigationController?.isNavigationBarHidden = comeFromAdd
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped(){
        print("we add a book")
    }
}

extension MyListOfBooksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of item in the data source array
        return collectionBooks.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create the cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: TextAndString.shared.myListOfBookCell,
                                                       for: indexPath)
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
            let cover = "\(collectionBooks[indexPath.row].bookIsbn).jpg"
            print("la cover = isbn \(cover)")
            print("let's download")
            let storageRef = Storage.storage().reference().child("cover").child(cover)
            print(storageRef.description)
            DispatchQueue.main.async {
                print("let's be inside")
                self.download = storageRef.getData(maxSize: 1024*1024*5, completion:  { [weak self] (data, error) in
                    print("let's be inside download")
                    if error != nil {
                        print("error here : \(error.debugDescription)")
                    }
                    guard let data = data else {
                        print("no data here")
                        return
                    }
                    if error != nil {
                        print("error here : \(error.debugDescription)")
                    }
                    print("download succeeded !")
                    imageViewBook.image = UIImage(data: data)
                    self!.download.resume()
                })
            }
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Title is \(collectionBooks[indexPath.row].bookTitle)")
        print("Author is \(collectionBooks[indexPath.row].bookAuthor)")
        print("bookEditor is \(collectionBooks[indexPath.row].bookEditor ?? "unknown")")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check the segue name
        if segue.identifier == "showBookDetailsSegue" {
            // si la destination est le VC DetailViewController, and set the index from the selected item
            if let dest = segue.destination as? BookDetailsViewController, let index = mycol.indexPathsForSelectedItems?.first {
                // Pass your datas
                dest.bookDetailsToDisplay = collectionBooks[index.row]
            }
        }
    }
    
}
extension MyListOfBooksViewController : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: (collectionViewWidth-24)/2, height: (collectionViewWidth-24)/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
