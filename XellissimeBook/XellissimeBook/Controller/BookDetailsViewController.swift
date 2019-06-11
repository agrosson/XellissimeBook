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
    //     navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Modify", style: .plain, target: self, action: #selector(ModifyTapped))
        let textMod = "Modify text"
        let coverMod = "Modify Cover"
        let itemsFarRight = UIBarButtonItem(title: textMod , style: .plain, target: self, action: #selector(modifyTapped))
        let itemsmiddle = UIBarButtonItem(title: "      ", style: .plain, target: self, action: nil)
        let centerItemsRight = UIBarButtonItem(title:coverMod , style: .plain, target: self, action: #selector(coverTapped))
        let arrayItem = [itemsFarRight,itemsmiddle,centerItemsRight]
        navigationItem.rightBarButtonItems = arrayItem
     //   itemsFarRight.imageInsets = UIEdgeInsets(top: 0.0, left: -100, bottom: 0, right: 0)
       //  itemsFarRight.imageInsets = UIEdgeInsets(top: 0.0, left: -100, bottom: 0, right: 0)
        itemsFarRight.titlePositionAdjustment(for: UIBarMetrics(rawValue: 150)!)
        centerItemsRight.titlePositionAdjustment(for: UIBarMetrics(rawValue: 150)!)
        bookTitleLabel.text = bookDetailsToDisplay.bookTitle
        bookAuthorLabel.text = bookDetailsToDisplay.bookAuthor
        bookEditorLabel.text = bookDetailsToDisplay.bookEditor
        
        let urlString = bookDetailsToDisplay.bookCoverURL
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
    
    @objc func modifyTapped(){
        print("ModifyTapped")
    }
    @objc func coverTapped(){
        print("coverTapped")
    }
}



