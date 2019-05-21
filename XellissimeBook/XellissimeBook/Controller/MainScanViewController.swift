//
//  MainScanViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class MainScanViewController: UIViewController {

    @IBOutlet weak var isbnScannedLabel: UILabel!
    @IBOutlet weak var exportIsbnButton: UIButton!
    @IBAction func startScanningIsPressed(_ sender: UIButton) {
    }
    @IBAction func exportIsbnIsPressed(_ sender: UIButton) {
        print(scannedIsbn)
        performSegue(withIdentifier: "unwindToAddMenu", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if scannedIsbn == "" {
            isbnScannedLabel.isHidden = true
            exportIsbnButton.isHidden = true
        } else {
            isbnScannedLabel.isHidden = false
            exportIsbnButton.isHidden = false
        }
        print("scan isbn is in didload : \(scannedIsbn)")
        isbnScannedLabel.text = "Isbn number: \(scannedIsbn)"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scannedIsbn == "" {
            isbnScannedLabel.isHidden = true
            exportIsbnButton.isHidden = true
        } else {
            isbnScannedLabel.isHidden = false
            exportIsbnButton.isHidden = false
        }
        print("scan isbn is in didload : \(scannedIsbn)")
        isbnScannedLabel.text = "Isbn number: \(scannedIsbn)"
    }
    @IBAction func unwindToMainScan(_ segue: UIStoryboardSegue) {
        // Do nothing
    }
}
