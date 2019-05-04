//
//  WelcomeViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 01/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    // MARK: - Outlets - Labels
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameWelcomeLabel: UILabel!
    // MARK: - Outlets - Buttons
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var goToMenuButton: UIButton!
     // MARK: - Actions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        // Disconnect
        do {
            try Auth.auth().signOut()
            logoutButton.isEnabled = false
            usernameWelcomeLabel.text = "Please log in"
            performSegue(withIdentifier: "unwindToMenu", sender: self)
        }
        catch {
            print("Impossible to disconnect because user not connected !!")
        }
    }
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if user already connected
        welcomeLabel.isHidden = true
        goToMenuButton.isHidden = true
        if let user = Auth.auth().currentUser {
            // Create a reference to the dataBase
            let ref = Database.database().reference()
            // Get the reference id of the user
            let usedId = user.uid
            // Get the value of an item in a dictionary
            ref.child("users").child(usedId).observeSingleEvent(of: .value) { (snapshot) in
                // define a variable as a dictionary
                let value = snapshot.value as? NSDictionary
                // Get the value of the dictionary with key = "userName"
                let userName = value?["userName"] as? String ?? "No user Name"
                // use the reponse as you need
                self.welcomeLabel.isHidden = false
                self.usernameWelcomeLabel.text = userName
                self.goToMenuButton.isHidden = false
            }
        } else {
            // Here do something if you get nothing
            fatalError("⛔️ ! There is no user connected")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            logoutButton.isEnabled = true
        } else {
            logoutButton.isEnabled = false
        }
    }
}
