//
//  MealTableViewController.swift
//  TestIOS
//
//  Created by EvampSaanga on 4/4/18.
//  Copyright © 2018 EvampSaanga. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    var meals = [Meal]()
    
    //MARK: Private Methods
    private func loadSampleMeals(){
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        let photo4 = UIImage(named: "meal4")
        
        guard let meal1  = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unalbe to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        guard let meal4 = Meal(name: "Bread with Eage", photo: photo4, rating: 2) else {
            fatalError("Unable to instantiate meal4")
        }
        
        meals += [meal1,meal2,meal3,meal4]
        
    }
    
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        }else{
            os_log("Failed to saved meals...", log: OSLog.default,type: .error)
        }
    }
    
    private func loadMeals()-> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meal, otherwise load simple data.
        if let savedData = loadMeals(){
            meals += savedData
        }else {
            // Load sample data
            loadSampleMeals()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellidentifier = "MealTableViewCell"
        
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not  an instance of MealTableViewCell")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
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
            meals.remove(at: indexPath.row)
            saveMeals()
         tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default,type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as?
                MealViewController else {
                    fatalError("Unexpected Destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by table")
            }
            
            let selectedMeal =  meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected segue indentifier; \(String(describing: segue.identifier))")
        }
        
     }
    
    
    //MARK: Actions
    
    @IBAction func pressedPlusbtn(_ sender: Any){
        //One way to move to Controler
//        self.performSegue(withIdentifier: "MealViewController", sender: self);
        // Other way to move from to controler
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MealViewController") as? MealViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        
        if let sourceViewControler = sender.source as?
            MealViewController, let meal = sourceViewControler.meal {
            
            if let selectedIndexPath =  tableView.indexPathForSelectedRow{
                // Update an exiting meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
    
                //Add new Meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)

                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the Meal
            saveMeals()
            
        }
        
    }
    
}