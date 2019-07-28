//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Theressa on 7/21/19.
//  Copyright © 2019 Donovan Taylor. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    //MARK: Class Constants and Variables
    
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        //cell.accessoryType = item.done == true ? .checkmark : .none
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        
        
        do {
            try self.context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error in fetching data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Todoey List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create List", style: .default) { (action) in
            if textField.text!.isEmpty {
                let blankAlert = UIAlertController(title: "List Title Can't Be Blank", message: "Please enter a name", preferredStyle: .alert)
                
                let blankAction1 = UIAlertAction(title: "Create List", style: .default) { (action) in
                    self.addButtonPressed(self.addButton)
                }
                let blankAction2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    print("Canceled")
                }
                
                blankAlert.addAction(blankAction1)
                blankAlert.addAction(blankAction2)
                
                self.present(blankAlert, animated: true, completion: nil)
                
            } else {
                
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveCategories()
                
            }
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - Search Bar Functions
}
