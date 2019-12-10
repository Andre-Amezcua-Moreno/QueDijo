//
//  HomeTableViewController.swift
//  QueDijo
//
//  Created by Andrea Amezcua Moreno on 12/4/19.
//  Copyright © 2019 Andrea Amezcua Moreno. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBAction func speechTranslator(_ sender: Any) {
        
    }
    
    @IBAction func realTimeTranslator(_ sender: Any) {
        
    }
    
    
    @IBAction func pictureTranslator(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


}
