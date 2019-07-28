//
//  ViewController.swift
//  Todoey
//
//  Created by Theressa on 7/7/19.
//  Copyright © 2019 Donovan Taylor. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    
    var strArray = ["Put right foot in","Take right foot out","Put right foot back in","Shake it all about (right foot)"]
    
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet {
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //let range: CountableClosedRange = 0...3
        
        /*
        for i in range {
            let newItem = Item(context: context)
            newItem.title = strArray[i]
            itemArray.append(newItem)
        }
        */
        
        
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //    itemArray = items
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
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
    
        //tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        
        
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
                
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
        
            }
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
        
        do {
            try self.context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        var predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let userPredicate = request.predicate {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,userPredicate])
        }
        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error in fetching data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
}


//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request)
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
