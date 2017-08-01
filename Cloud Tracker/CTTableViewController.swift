//
//  CTTableViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class CTTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddMealDelegate, DetailedRatingDelegate {

  @IBOutlet weak var tableView: UITableView!
  var token: String?
  var listOfMeals: [Meal] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    if (listOfMeals.isEmpty)
    {
      performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    getMealList()
  }
  
  func getMealList ()
  {
    if (NetworkManager.sharedManager.isLoggedIn)
    {
      NetworkManager.sharedManager.loadUserMeals {(meals: [Meal]) in
        self.listOfMeals = meals
        OperationQueue.main.addOperation({ 
          self.tableView.reloadData()
        })
      }
    }
  }
  
  
  // Mark: Delegate Methods
  func addMeal(meal: Meal)
  {
    NetworkManager.sharedManager.postNewMeal(meal: meal) {
      OperationQueue.main.addOperation({
        self.getMealList()
      })
    }
  }
  
  func updateMealRating(meal: Meal)
  {
    NetworkManager.sharedManager.updateRating(meal: meal) {
      OperationQueue.main.addOperation({
        self.getMealList()
      })
    }
  }
  
  // MARK: UITableView DataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.listOfMeals.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ctCell", for: indexPath) as! CTTableViewCell
    
    cell.meal = self.listOfMeals[indexPath.row]
    
    return cell
  }
  
  // MARK: UITableView Delegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    performSegue(withIdentifier: "detailSegue", sender: indexPath)
  }
  
  
  // MARK: Navigation Methods
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if (segue.identifier == "loginSegue")
    {
    }
    if (segue.identifier == "detailSegue")
    {
      let dvc = segue.destination as! CTDetailedViewController
      let indexPath = sender as! IndexPath
      dvc.delegate = self
      dvc.meal = listOfMeals[indexPath.row]
    }
    if (segue.identifier == "addSegue")
    {
      let nav = segue.destination as! UINavigationController
      let dvc = nav.viewControllers[0] as! CTAddMealViewController
      dvc.delegate = self
    }
  }
}

