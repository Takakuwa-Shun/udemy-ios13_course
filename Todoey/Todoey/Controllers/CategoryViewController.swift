//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 高桑駿 on 2020/04/17.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

//    var categoryArray = [`Category`]()
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    
    // CoreData
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
        } else {
            cell.textLabel?.text = "add new category"
        }

        return cell
    }
    
    // Libraryを使わない方法
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "add new Category", message: "", preferredStyle: .alert)
        
        var textField: UITextField?
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "input category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            if let text = textField?.text {
//           CoreData
//              let category = Category(context: self.context)
                let category = Category()
                category.name = text
                category.color = UIColor.randomFlat().hexValue()
//              self.categoryArray.append(category)
                self.save(category: category)
//              self.saveCategory()
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Realm
    
    
    func loadCategory() -> Void {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) -> Void {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) -> Void {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(category)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    //MARK: - Core Data
    
    
//    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) -> Void {
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
//    }

//    func saveCategory() -> Void {
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
//    }
}
