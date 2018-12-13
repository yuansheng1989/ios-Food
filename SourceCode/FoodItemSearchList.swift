//
//  FoodItemSearchList.swift
//  Food
//
//  Created by Yuansheng Lu on 2018-11-28.
//  Copyright © 2018 SICT. All rights reserved.
//

import UIKit

protocol SelectFoodItemDelegate: class {
    
    func selectTaskDidCancel(_ controller: UIViewController)
    
    // Use the correct type for the "item" - change from "Any"
    func selectTask(_ controller: UIViewController, didSelect item: NdbSearchListItem)
}

class FoodItemSearchList: UITableViewController {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    
    weak var delegate: SelectFoodItemDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("WebApiDataIsReady"), object: nil)
        
    }
    
    // Method that runs when the notification happens
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Call into the delegate
        delegate?.selectTaskDidCancel(self)
    }
    
    // MARK: - Table view methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let temp = m.ndbSearchPackage?.list.item.count {
            return temp
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = m.ndbSearchPackage?.list.item[indexPath.row].name
        cell.detailTextLabel?.text = m.ndbSearchPackage?.list.item[indexPath.row].manu
        
        return cell
    }
    
    // Responds to a row selection event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Work with the selected item
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            
            // Show a check mark
            selectedCell.accessoryType = .checkmark
            
            // Fetch the data for the selected item
            let data = m.ndbSearchPackage?.list.item[indexPath.row]
            
            // Call back into the delegate
            delegate?.selectTask(self, didSelect: data!)
        }
    }
    
    
}

// Sample delegate method implementations
// Copy to the presenting controller's "Lifecycle" area

/*
 func selectTaskDidCancel(_ controller: UIViewController) {
 
 dismiss(animated: true, completion: nil)
 }
 
 // Use the correct type for the "item"
 func selectTask(_ controller: UIViewController, didSelect item: Any) {
 
 // Do something with the item
 
 dismiss(animated: true, completion: nil)
 }
 */
