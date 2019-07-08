//
//  ViewController.swift
//  Todoey
//
//  Created by Theressa on 7/7/19.
//  Copyright © 2019 Donovan Taylor. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var strArray = ["Put right foot in","Take right foot out","Put right foot back in","Shake it all about (right foot)"]
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let range: CountableClosedRange = 0...3
        for i in range {
            let newItem = Item()
            newItem.title = strArray[i]
            itemArray.append(newItem)
        }
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    
    //MARK - Tableview Datasource
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        // This ^ does the job of this below
        /*
        if item.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        */
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text!.isEmpty {
                let blankAlert = UIAlertController(title: "Item Can't Be Blank", message: "Please enter a name", preferredStyle: .alert)
                
                let blankAction1 = UIAlertAction(title: "Add Item", style: .default) { (action) in
                    self.addButtonPressed(self.addButton)
                }
                let blankAction2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    print("Canceled")
                }
                
                blankAlert.addAction(blankAction1)
                blankAlert.addAction(blankAction2)
        
                self.present(blankAlert, animated: true, completion: nil)
                
            } else {
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
    }
    
}

