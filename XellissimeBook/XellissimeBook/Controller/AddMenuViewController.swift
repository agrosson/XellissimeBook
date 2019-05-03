//
//  AddMenuViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class AddMenuViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var addManuallyButton: UIButton!
    @IBOutlet weak var addWithCameraButton: UIButton!
    // MARK: - Actions
    
    @IBAction func addManuallyButtonIsPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToAddManually", sender: self)
    }
    
    @IBAction func addWithCameraButtonIsPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToAddWithCamera", sender: self)
    }
    
    @IBAction func backToAddMenu(segue: UIStoryboardSegue){
        
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

}
