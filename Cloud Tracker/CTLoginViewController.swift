//
//  CTLoginViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class CTLoginViewController: UIViewController {
  
  @IBOutlet weak var loginScrollView: UIScrollView!
  @IBOutlet weak var usernameLoginTextField: UITextField!
  @IBOutlet weak var passwordLoginTextField: UITextField!
  @IBOutlet weak var checkMarkImageView: UIImageView!
  @IBOutlet weak var logoImageView: UIImageView!
  
  var isRememberMe: Bool! = false
  
  let alertController = UIAlertController(title: "Invalid username/password", message: "Invalid username/password", preferredStyle: UIAlertControllerStyle.alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    NetworkManager.sharedManager.loadUserDefaults { (isRememberMe:Bool,username:String,password:String) in
      OperationQueue.main.addOperation({
        self.isRememberMe = isRememberMe
        self.checkMarkImageView.isHidden = !isRememberMe
        if (isRememberMe)
        {
          self.usernameLoginTextField.text = username
          self.passwordLoginTextField.text = password
        }
      })
    }
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
  }
  
  @IBAction func loginButton(_ sender: UIButton)
  {
    let username = usernameLoginTextField.text!
    let password = passwordLoginTextField.text!
    let identifier = "/login"
    if (username != "" && password != "")
    {
      NetworkManager.sharedManager.userLoginSignUp(username: username, password: password, identifier: identifier, completionHandler:
        { (response: Bool) in
          if (!response)
          {
            OperationQueue.main.addOperation({
              self.present(self.alertController, animated: true)
            })
          } else {
            OperationQueue.main.addOperation({
              if (NetworkManager.sharedManager.isLoggedIn)
              {
                NetworkManager.sharedManager.saveUserDefaults(isRememberMe: self.isRememberMe)
              }
              self.dismiss(animated: true, completion: nil)
            })
          }
      })
      
    } else {
      self.present(alertController, animated: true)
    }
  }
  
  @IBAction func rememberMeButton(_ sender: UIButton) {
    isRememberMe = !isRememberMe
    checkMarkImageView.isHidden = !checkMarkImageView.isHidden
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    //    let nav = segue.destination as! UINavigationController
    //    let dvc = nav.viewControllers[0] as! CTTableViewController
    //    dvc.token = sender as? String
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
//    view.endEditing(true)
  }
}
