//
//  BookListTableViewCell.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 08/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class BookListTableViewCell: UITableViewCell {

    // MARK: - Outlet - ImageView
    @IBOutlet weak var bookAvailabilityImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    // MARK: - Outlet - Labels
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookEditorLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: - Methods
    /**
     Function that configures the cell in the List of books table view
     - Parameter imageCover: cover image of the book
     - Parameter title: title of the book
     - Parameter author: author(s) of the book
     - Parameter editor: editor(s) of the book
     */
    func configure(isbn: String, title: String, author: String, editor: String) {
        // todo : bookAvailabilityImage will be configured later
        var download: StorageDownloadTask!
        let cover = "\(isbn).jpg"
        let storageRef = Storage.storage().reference().child("cover").child(cover)
        print(storageRef.description)
        //  download = StorageDownloadTask()
        DispatchQueue.main.async {
            print("let's be inside")
            download = storageRef.getData(maxSize: 1024*1024*5, completion:  { [weak self] (data, error) in
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
                self!.coverImage.image = UIImage(data: data)
                download.resume()
            })
        }
        
        bookTitleLabel.text = title
        bookAuthorLabel.text = author
        bookEditorLabel.text = editor
    }
    
}
