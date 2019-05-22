//
//  BookDetailsViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    var bookDetailsToDisplay: Book!
    
    @IBOutlet weak var coverBookImage: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookEditorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookTitleLabel.text = bookDetailsToDisplay.bookTitle
        bookAuthorLabel.text = bookDetailsToDisplay.bookAuthor
        bookEditorLabel.text = bookDetailsToDisplay.bookEditor
        
        guard let urlString = bookDetailsToDisplay.bookCoverURL else {return}
        if let url = URL(string: urlString) {
            let data = try? Data(contentsOf: url)
            if let datatNotNil = data {
                print("ou là")
                coverBookImage.image = UIImage(data: datatNotNil)
            }
        } else {
            print("on est bien là?")
            coverBookImage.image = UIImage(named: "notebook.png")
        }
    }
}

