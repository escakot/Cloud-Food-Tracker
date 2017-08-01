//
//  CTSignUpViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-08-01.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class CTSignUpViewController: UIViewController {

  @IBOutlet weak var usernameSignUpTextField: UITextField!
  @IBOutlet weak var passwordSignUpTextField: UITextField!
  let alertController = UIAlertController(title: "Invalid username/password", message: "Username already exists", preferredStyle: UIAlertControllerStyle.alert)
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
    }

  @IBAction func signUpButton(_ sender: UIButton)
  {
    let username = usernameSignUpTextField.text!
    let password = passwordSignUpTextField.text!
    let identifier = "/signup"
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
              self.view.window!.rootViewController?.dismiss(animated: false)
            })
          }
      })
      
    } else {
      self.present(alertController, animated: true)
    }
  }
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

