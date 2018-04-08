//
//  ViewController.swift
//  Search Bar
//
//  Created by Ian Yang on 3/26/18.
//  Copyright © 2018 Ian Yang. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    var searchActive : Bool = false
    
    var items = [BeastListItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        fetchAllItems()
        searchBar.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            fetchAllItems()
            self.tableView.reloadData()
            

        } else {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeastListItem")
        let mypredicate = NSPredicate(format: "text CONTAINS[cd] %@", searchText)
        request.predicate = mypredicate

        
        do{
            let result = try manageObjectContext.fetch(request)
            items = result as! [BeastListItem]
            print(items)
        } catch {
            print("\(error)")
        }
        self.tableView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, AddItemViewControllerDelegate {
    
    func fetchAllItems() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeastListItem")

        do{
            let result = try manageObjectContext.fetch(request)
            items = result as! [BeastListItem]
            print(items)
        } catch {
            print("\(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
   

        cell.textLabel?.text = items[indexPath.row].text
        return cell
    }
    
    func cancelButtonPressed(by controller: AddItemViewController) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addItemSegue", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemViewController = navigationController.topViewController as! AddItemViewController
        addItemViewController.delegate = self
        
        if let indexPath = sender as? IndexPath {
            let item = items[indexPath.row]
            addItemViewController.text = item.text!
            
            addItemViewController.indexPath = indexPath
            
        }
    }
    func itemSaved(by controller: AddItemViewController, with text: String, at indexPath: IndexPath?) {
        if let ip = indexPath {
            let item = items[ip.row]
            item.text = text
            
        } else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "BeastListItem", into: manageObjectContext) as! BeastListItem
            item.text = text
           
            items.append(item)
            
        }
        
        appDelegate.saveContext()
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        print(item)
        manageObjectContext.delete(item)
        appDelegate.saveContext()
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
  
}

