//
//  ViewController.swift
//  ToDoApp
//
//  Created by Barış Can Akkaya on 14.06.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var missionArray = [Mission]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        loadSavedData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { alert in
            let newToDo = Mission(context: self.context)
            newToDo.mission = textField.text
            newToDo.checkmark = false
            newToDo.id = UUID()
            self.missionArray.append(newToDo)
            self.saveDatas()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                           style: .cancel)
        
        alert.addTextField { uiTextField in
            uiTextField.placeholder = "Create a new item"
            textField = uiTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let mission = missionArray[indexPath.row]
        cell.textLabel?.text = missionArray[indexPath.row].mission
        cell.accessoryType = mission.checkmark ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionArray[indexPath.row].checkmark = !missionArray[indexPath.row].checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(missionArray[indexPath.row])
            missionArray.remove(at: indexPath.row)
            saveDatas()
        } else if editingStyle == .insert {
            print("anan")
        }
    }
    
    func saveDatas() {
        do {
            try context.save()
        } catch {
            print("Error")
        }
        tableView.reloadData()
    }
    
    func loadSavedData() {
        let request :NSFetchRequest<Mission> = Mission.fetchRequest()
        do {
            missionArray = try context.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}



