//
//  WelcomeViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 01/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
// MARK: - Outlets - Labels
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameWelcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if user already connected
        if let user = Auth.auth().currentUser {
            // there is a user connected
            let userEmail = user.email
            usernameWelcomeLabel.text = userEmail
        } else {
            fatalError("⛔️ ! There is no user connected")
        }
        
    }
    

}
