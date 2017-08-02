//
//  Meal.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class Meal: NSObject {
  
  var title: String?
  var mealDescription: String?
  var imagePath: String?
  var calories: Int?
  var id: Int?
  var rating: Int?
  var imageData: Data? = nil
  
  override init() {
    title = ""
    mealDescription = ""
    imagePath = nil
    calories = 0
    id = nil
    rating = 0
  }
  
  init(with info:[String:AnyObject]) {
    title = info["title"] as? String
    mealDescription = info["description"] as? String
    imagePath = info["imagePath"] as? String
    calories = info["calories"] as? Int
    id = info["id"] as? Int
    rating = info["rating"] as? Int
  }

}
