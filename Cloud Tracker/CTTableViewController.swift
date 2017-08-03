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
  let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //Activity Indicator Setup
    activityIndicator.frame.origin.x = view.frame.size.width/2 - activityIndicator.frame.width/2
    activityIndicator.frame.origin.y = view.frame.size.height/2 - activityIndicator.frame.height/2
    view.addSubview(activityIndicator)
    
    //Refresh Control
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
    tableView.addSubview(refreshControl)
    
    //Present Login
    if (listOfMeals.isEmpty)
    {
      performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    if (listOfMeals.isEmpty)
    {
      activityIndicator.startAnimating()
      getMealList()
    }
  }
  
  func refreshPull ()
  {
    activityIndicator.startAnimating()
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
          self.activityIndicator.stopAnimating()
          self.refreshControl.endRefreshing()
        })
      }
    }
  }
  
  
  // Mark: Delegate Methods
  func addMeal(meal: Meal)
  {
    activityIndicator.startAnimating()
    NetworkManager.sharedManager.postNewMeal(meal: meal) { (savedMeal:Meal) in
      NetworkManager.sharedManager.updateRating(meal: savedMeal, completionHandler: {
        NetworkManager.sharedManager.postPhotoToImgur(meal:savedMeal, completionHandler: { (mealWithPhoto: Meal) in
          NetworkManager.sharedManager.updateImagePath(meal: mealWithPhoto, completionHandler: {
            OperationQueue.main.addOperation({
              self.getMealList()
            })
          })
        })
      })
    }
  }
  
  func updateMeal(meal: Meal)
  {
    activityIndicator.startAnimating()
    NetworkManager.sharedManager.updateRating(meal: meal) {
      NetworkManager.sharedManager.postPhotoToImgur(meal:meal, completionHandler: { (mealWithPhoto: Meal) in
        NetworkManager.sharedManager.updateImagePath(meal: mealWithPhoto, completionHandler: {
          OperationQueue.main.addOperation({
            self.getMealList()
          })
        })
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
  
  @IBAction func logoutButton(_ sender: UIBarButtonItem)
  {
    performSegue(withIdentifier: "loginSegue", sender: nil)
    listOfMeals = []
    tableView.reloadData()
  }
  
  
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

