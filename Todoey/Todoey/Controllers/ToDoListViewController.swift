//
//  ViewController.swift
//  Todoey
//
//  Created by 高桑駿 on 2020/03/26.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
//    var itemArray = [Item]()
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
//             let requst: NSFetchRequest<Item> = Item.fetchRequest()
//             requst.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//             loadItems(with: requst)
            
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("items.plist")
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "add new Todoey Item", message: "", preferredStyle: .alert)
        
        var textField: UITextField?
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            let text = textField?.text ?? "new item"
            
//            Core Data
//            let item = Item(context: self.context)
//            item.title = text
//            item.done = false
//            item.parentCategory = self.selectedCategory
//            self.itemArray.append(item)
//            self.saveItem()
            
            // Realm
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let item = Item()
                        item.title = text
                        item.color = UIColor.randomFlat().hexValue()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print(error)
                }
            }

            
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - tableview datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: item.color)
        } else {
            cell.textLabel?.text = "no item added"
        }
        
        return cell
    }
    
    //MARK: - tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        
        // Realm
        if let item = self.itemArray?[indexPath.row] {
            do {
                try self.realm.write{
//                    self.realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
            cell?.accessoryType = item.done ? .checkmark : .none
        }
        
        // Core Data
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
//        let done = !itemArray?[indexPath.row].done
//
//        itemArray[indexPath.row].done = done
//        self.saveItem()
//        cell?.accessoryType = done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Realm
    
    func loadItems() -> Void {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) -> Void {
        if let item = self.itemArray?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    //MARK: - Core Data
    
//    func saveItem() -> Void {
//        do {
//            try context.save()
//            tableView.reloadData()
//        } catch {
//            print(error)
//        }
//    }
//
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) -> Void {
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
//    }
    
    //MARK: - for UserDefaults, to save ~.plist
    
//    func saveItem() -> Void {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print(error)
//        }
//    }
    
//    func loadItems() -> Void {
//        if let data = try? Data(contentsOf: self.dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print(error)
//            }
//        } 
//
//    }
}

//MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        Realm
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
//        Core Data
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate1 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        let predicate2 = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//            loadItems(with: request)
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
