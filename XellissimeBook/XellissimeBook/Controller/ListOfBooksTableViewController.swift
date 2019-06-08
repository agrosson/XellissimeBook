//
//  ListOfBooksTableViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 08/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class ListOfBooksTableViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.reloadData()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension ListOfBooksTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
