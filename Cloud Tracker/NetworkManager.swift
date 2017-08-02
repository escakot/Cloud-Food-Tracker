//
//  NetworkManager.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-08-01.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
  
  var components = URLComponents(string:"https://cloud-tracker.herokuapp.com")
  var usernameInfo: String!
  var passwordInfo: String!
  var token: String!
  var isLoggedIn: Bool! = false
  let userDefaults = UserDefaults.standard
  
  private override init() { }
  
  static let sharedManager = NetworkManager()
  
  func userLoginSignUp (username:String, password:String, identifier:String, completionHandler: @escaping (Bool) -> Void)
  {
    components?.path = identifier
    let usernameQuery = URLQueryItem(name: "username", value: username)
    let passwordQuery = URLQueryItem(name: "password", value: password)
    components?.queryItems = [usernameQuery, passwordQuery]
    var urlRequest = URLRequest(url: components!.url!)
    urlRequest.httpMethod = "POST"
    performQuery(with: urlRequest) { (data: Data) in
      do {
        let responseData = try JSONSerialization.jsonObject(with: data, options:[]) as! [String:AnyObject]
//        print(responseData.description)
        guard responseData["username"] as? String != nil, responseData["password"] as? String != nil else {
          completionHandler(false)
          return
        }
        self.usernameInfo = responseData["username"] as! String
        self.passwordInfo = responseData["password"] as! String
        self.token = responseData["token"] as! String
        self.isLoggedIn = true;
        completionHandler(true)
      } catch {
        completionHandler(false)
        print(error.localizedDescription)
      }
    }
  }
  
  func loadUserMeals (completionHandler: @escaping ([Meal]) -> Void)
  {
    components?.path = "/users/me/meals/"
    var urlRequest = URLRequest(url: components!.url!)
    urlRequest.allHTTPHeaderFields = ["Content-Type":"application/json","token":token]
    urlRequest.httpMethod = "GET"
    performQuery(with: urlRequest) { (data: Data) in
      do {
        let responseData = try JSONSerialization.jsonObject(with: data, options:[]) as! [[String:AnyObject]]
        var mealArray: [Meal] = []
//        print (responseData.description)
        for mealDict in responseData
        {
          let meal = Meal(with: mealDict)
          mealArray.append(meal)
        }
        completionHandler(mealArray)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func postNewMeal (meal:Meal, completionHandler: @escaping (Meal) -> Void)
  {
    components?.path = "/users/me/meals/"
    let titleQuery = URLQueryItem(name: "title", value: meal.title!)
    let descriptionQuery = URLQueryItem(name: "description", value: meal.mealDescription!)
    let caloriesQuery = URLQueryItem(name: "calories", value: String(format: "%li", meal.calories!))
    components?.queryItems = [titleQuery, descriptionQuery, caloriesQuery]
    
    var urlRequest = URLRequest(url: components!.url!)
    urlRequest.httpMethod = "POST"
    urlRequest.allHTTPHeaderFields = ["Content-Type":"application/json","token":token]
    
    performQuery(with: urlRequest) { (data: Data) in
      
      do {
        let responseData = try JSONSerialization.jsonObject(with: data, options:[]) as! [String:AnyObject]
        print(responseData.description)
        let newMeal = Meal(with: responseData["meal"]! as! [String : AnyObject])
        newMeal.rating = meal.rating!
        completionHandler(newMeal)
      } catch {
        print(error.localizedDescription)
      }
    }
    
  }
  
  func updateRating (meal:Meal, completionHandler: @escaping () -> Void)
  {
    
    components?.path = String(format: "/users/me/meals/%li/rate", meal.id!)
    let ratingQuery = URLQueryItem(name: "rating", value: String(format: "%li", meal.rating!))
    components?.queryItems = [ratingQuery]
    
    var urlRequest = URLRequest(url: components!.url!)
    urlRequest.httpMethod = "POST"
    urlRequest.allHTTPHeaderFields = ["Content-Type":"application/json","token":token]
    
    performQuery(with: urlRequest) { (data: Data) in
      completionHandler()
    }
    
  }
  
  func updatePhoto (meal:Meal, completionHandler: @escaping () -> Void)
  {
    components?.path = String(format: "/users/me/meals/%li/photo", meal.id!)
    var urlRequest = URLRequest(url: components!.url!)
    urlRequest.httpMethod = "POST"
//    urlRequest.httpBody = 
  }
  
  // MARK: UserDefault Methods
  
  func saveUserDefaults(isRememberMe:Bool)
  {
    guard usernameInfo != nil, passwordInfo != nil else {
      return
    }
    userDefaults.set(isRememberMe, forKey: "rememberMe")
    userDefaults.set(usernameInfo, forKey: "username")
    userDefaults.set(passwordInfo, forKey: "password")
    userDefaults.synchronize()
  }
  
  func loadUserDefaults(completionHandler: @escaping (Bool, String, String) -> Void)
  {
    guard userDefaults.value(forKey: "rememberMe") != nil else {
      return
    }
    let isRememberMe = userDefaults.value(forKey: "rememberMe") as! Bool
    let username = userDefaults.value(forKey: "username") as! String
    let password = userDefaults.value(forKey: "password") as! String
    completionHandler(isRememberMe, username, password)
  }
  
  // MARK: Query Method
  func performQuery(with urlRequest:URLRequest, returnJSONData: @escaping (Data) -> ())
  {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let dataTask = session.dataTask(with: urlRequest)
    { (data: Data?, response: URLResponse?, error: Error?) in
      if (error != nil)
      {
        print(error!.localizedDescription)
      }
      
      returnJSONData(data!)
    }
    dataTask.resume()
  }
  
  
}
