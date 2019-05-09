//
//  MyListOfBooksViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 06/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class MyListOfBooksViewController: UIViewController {
    // MARK: - Properties
    
    var book = Book(title: "le livre", author: "l'auteur", isbn: "l'isbn")
    var book2 = Book(title: "le livre 2", author: "l'auteur 2", isbn: "l'isbn 2")
    
    var collectionBooks = [Book]()
    
    var collectionOfImageBooks = [UIImage]()
    let imageDefault = UIImage.init(named: "metronome")
    let imageDefault1 = UIImage.init(named: "notebook")
    var imagefromFire : UIImage?
    var imagefromFire2 : UIImage?
    
    // MARK: - Outlet
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         // MARK: - Todo
    
        // upload the book of the users in collectionBooks
        
        //
        
        

        downloadImage()
        downloadImage2()
        
        
      //  let size = CGSize(width: 70, height: 70)
     //   let newimage1 = resizeImage(image: imageDefault!, targetSize: size)
     //   let newimage2  = resizeImage(image: imageDefault1!, targetSize: size)
        book.bookEditor = "Editor0"
        book2.bookEditor = "Editor2"
        for _ in 1...15 {
            collectionBooks.append(book)
            collectionBooks.append(book2)
            // test if image is correct
            collectionOfImageBooks.append(imagefromFire ?? imageDefault1!)
            collectionOfImageBooks.append(imagefromFire2 ?? imageDefault1!)
        }
       print(collectionOfImageBooks as Any)
        // Do any additional setup after loading the view.
    }
    
   
    private func downloadImage() {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/xellissimebook.appspot.com/o/metronome.jpg?alt=media&token=6fffa251-a1d8-44b9-b5dc-68caaaf79b69")
        print("test1")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
             print("test2")

                self.imagefromFire = UIImage(data: data!)
                 print("test3")
            }
   
    private func downloadImage2() {
        let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/xellissimebook.appspot.com/o/frelon.jpg?alt=media&token=c8b8b584-2ee5-497c-bb99-3f45dbbb112b" )
        print("test1")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        print("test2")
        
        self.imagefromFire2 = UIImage(data: data!)
        print("test3")
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
             print("on passe là1?")
        }
        if let labelAuthor = cell.viewWithTag(101) as?  UILabel {
            labelAuthor.text = collectionBooks[indexPath.row].bookAuthor
             print("on passe là2?")
        }
        if let labelEditor = cell.viewWithTag(102) as?  UILabel {
            labelEditor.text = collectionBooks[indexPath.row].bookEditor
              print("on passe là3?")
        }
        if let imageViewBook = cell.viewWithTag(199) as? UIImageView {
            imageViewBook.image = collectionOfImageBooks[indexPath.row]
            print("on passe ici?")
        }
        return cell
        
    }
}
