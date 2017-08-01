//
//  CTTableViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class CTTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    if (NetworkManager.sharedManager.isLoggedIn) {
      NetworkManager.sharedManager.loadUserMeals {(meals: [Meal]) in
        self.listOfMeals = meals
        OperationQueue.main.addOperation({ 
          self.tableView.reloadData()
        })
      }
    }
  }
  
  @IBAction func addMeal(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "detailSegue", sender: nil)
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
      let indexPath = sender as! IndexPath
      let dvc = segue.destination as! CTDetailedViewController
      dvc.meal = listOfMeals[indexPath.row]
    }
  }
}

