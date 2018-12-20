//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Bhavya D J on 15/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var listView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refreshTableView()
    }
    
    // Refresh table data
    func refreshTableView() {
        if let listView = listView {
            listView.reloadData()
        }
    }
    
    
    //MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get cell type
        let cellReuseIdentifier = "TableViewCell"
        let studentLocations = StudentData.sharedInstance.arrayOfStudentLocations
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        //Set cell defaults
        let first = studentLocations[indexPath.row].firstName
        let last = studentLocations[indexPath.row].lastName
        let mediaURL = studentLocations[indexPath.row].mediaURL
        cell.textLabel!.text = "\(first ?? "") \(last ?? "")"
        cell.imageView!.image = UIImage(named: "icon_pin")
        cell.detailTextLabel!.text = mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.sharedInstance.arrayOfStudentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Open mediaURL
        let app = UIApplication.shared
        let url = StudentData.sharedInstance.arrayOfStudentLocations[indexPath.row].mediaURL
        
        
        print("verifyURL: \(verifyUrl(urlString: url))")
        
        if verifyUrl(urlString: url) == true {
            app.open(URL(string: url!)!)
            
        } else {
            
            performUIUpdatesOnMain {
                self.createAlert(title: "Invalid URL", message: "Could not open URL.")
            }
        }
    }
}
