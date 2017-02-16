//
//  ToDoTableViewController.swift
//  To Do List
//
//  Created by William Farley on 2/15/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var toDoArray = [String]()
    
    var toDoNotes = [String]()
    
    var defaultsData = UserDefaults.standard
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        toDoArray = defaultsData.stringArray(forKey: "toDoArray") ?? [String]()
        toDoNotes = defaultsData.stringArray(forKey: "toDoNotes") ?? [String]()
        
        if toDoArray.count == 0 {
            toDoNotes = [String]()
        }
        if toDoNotes.count == 0 {
            toDoArray = [String]()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        return toDoArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = toDoArray[indexPath.row]
        cell.detailTextLabel?.text = toDoNotes[indexPath.row]

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            toDoArray.remove(at: indexPath.row)
            toDoNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        defaultsData.set(toDoArray, forKey: "toDoArray")
        defaultsData.set(toDoNotes, forKey: "toDoNotes")
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let itemToMove = toDoArray[fromIndexPath.row]
        let noteToMove = toDoNotes[fromIndexPath.row]
        
        toDoArray.remove(at: fromIndexPath.row)
        toDoNotes.remove(at: fromIndexPath.row)
        
        toDoArray.insert(itemToMove, at: to.row)
        toDoNotes.insert(noteToMove, at: to.row)
        
        defaultsData.set(toDoArray, forKey: "toDoArray")
        defaultsData.set(toDoArray, forKey: "toDoNotes")
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let destinationViewController = segue.destination as! DetailViewController
            let selectedToDo = toDoArray[indexPath.row]
            let selectedToDoNote = toDoNotes[indexPath.row]
            destinationViewController.toDoItem = selectedToDo
            destinationViewController.toDoNote = selectedToDoNote
        }
    }
 

    @IBAction func unwindToTableViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DetailViewController, let toDoItem = sourceViewController.toDoItem {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                toDoArray[selectedIndexPath.row] = toDoItem
                if let toDoNote = sourceViewController.toDoNote {
                    toDoNotes[selectedIndexPath.row] = toDoNote
                } else {
                    toDoNotes[selectedIndexPath.row] = ""
                }
                tableView.reloadRows(at: [selectedIndexPath], with: .none)

                } else {
                toDoArray.append(toDoItem)
                    if let toDoNote = sourceViewController.toDoNote {
                        toDoNotes.append(toDoNote)
                    } else {
                        toDoNotes.append("")
                    }
            let newIndexPath = IndexPath(row: toDoArray.count-1, section: 0)
                tableView.insertRows(at: [newIndexPath], with: .bottom) }
        }
        
        defaultsData.set(toDoArray, forKey: "toDoArray")
        defaultsData.set(toDoNotes, forKey: "toDoNotes")
    }
    
}
