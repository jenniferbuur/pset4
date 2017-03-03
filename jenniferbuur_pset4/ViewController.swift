//
//  ViewController.swift
//  jenniferbuur_pset4
//
//  Created by Jennifer Buur on 28-02-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDataSource {

    var labels = [String]()
    
    //MARK: storyboard items
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var todoTextField: UITextField!
    @IBOutlet var addButton: UIButton!
//    
//    @IBAction func textFieldClicked(_ sender: Any) {
//        self.todoTextField.frame.origin.y -= 150
//        self.addButton.frame.origin.y -= 150
//        self.tableView.frame. -= 150
//    }
    @IBAction func addButtonClicked(_ sender: Any) {
        let insert = todolist.insert(todos <- todoTextField.text!)
        do {
            try db!.run(insert)
        } catch {
            alertUser(title: "Oops", message: "Could not create new todo")
            print("Error creating todo: \(error)")
        }
        searchAll()
        self.tableView.reloadData()
        todoTextField.text = ""
    }
    
    // MARK: to search database for todos
    func searchAll() {
        labels.removeAll()
        do {
            for todo in try db!.prepare(todolist) {
                if todo[todos].isEmpty != true {
                    labels.append(todo[todos])
                }
            }
        } catch {
            print("Did not find anything: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatabase()
        createTable()
        searchAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: create database and table
    private var db: Connection?
    let todolist = Table("todolist")
    let todos = Expression<String>("todos")
    
    // making database
    private func setUpDatabase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            alertUser(title: "Oops", message: "Could not connect to database")
            print("Cannot connect to database: \(error)");
        }
    }
    
    // making table
    private func createTable() {
        do {
            try db!.run(todolist.create(ifNotExists: true) { t in
                t.column(todos, unique: true)
            })
        } catch {
            alertUser(title: "Oops", message: "Failed to create table")
            print("Failed to create table: \(error)")
        }
    }
    
    //MARK: alertuser function
    func alertUser(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        return
    }
    
    
    //MARK: tableviewdatasource
    // making tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCellTableViewCell
        
        newCell.todos.text = labels[indexPath.row]
        
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let item = todolist.filter(todos == labels[indexPath.row])
            do {
                try db!.run(item.delete())
                searchAll()
            } catch {
                print("Could not delete todo: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
