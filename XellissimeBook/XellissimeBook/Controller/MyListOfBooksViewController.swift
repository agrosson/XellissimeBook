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
    let imageDefault = UIImage.init(named: "notebook")
    
    // MARK: - Outlet
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        book.bookEditor = "Editor0"
        book2.bookEditor = "Editor2"
        for _ in 1...15 {
            collectionBooks.append(book)
            collectionBooks.append(book2)
            // test if image is correct
            collectionOfImageBooks.append(imageDefault!)
            collectionOfImageBooks.append(imageDefault!)
        }
       
        // Do any additional setup after loading the view.
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
        if let imageViewBook = cell.viewWithTag(200) as? UIImageView {
            imageViewBook.image = collectionOfImageBooks[indexPath.row]
            imageViewBook.sizeToFit()
        }
        return cell
        
    }
    
    
}
