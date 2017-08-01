//
//  CTAddMealViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-08-01.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

protocol AddMealDelegate: class
{
  
  func addMeal(meal:Meal)
  
}

class CTAddMealViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var detailedImageView: UIImageView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var detailRatingLabel: UILabel!
  @IBOutlet weak var caloriesTextField: UITextField!
  
  let starRating = ["☆☆☆☆☆", "★☆☆☆☆","★★☆☆☆", "★★★☆☆", "★★★★☆", "★★★★★"]
  weak var delegate:AddMealDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    descriptionTextView.layer.borderColor = UIColor.gray.cgColor
    descriptionTextView.layer.borderWidth = 1.0
    
    let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ratingLabelTapped(sender:)))
    detailRatingLabel.addGestureRecognizer(tapGesture)
    detailRatingLabel.isUserInteractionEnabled = true
  }
  
  @IBAction func saveButton(_ sender: UIBarButtonItem) {
    let meal = Meal()
    meal.title = titleTextField.text
    meal.mealDescription = descriptionTextView.text
    meal.calories = Int(caloriesTextField.text!)
    meal.rating = starRating.index(of: detailRatingLabel.text!)
    
    delegate!.addMeal(meal: meal)
    dismiss(animated: true)
  }
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  // MARK: TextView Delegate
  func textViewDidBeginEditing(_ textView: UITextView)
  {
    if (textView.text == "\n\n\nMeal Description")
    {
      textView.textColor = UIColor.black
      textView.text = ""
    }
  }
  func textViewDidEndEditing(_ textView: UITextView)
  {
    if (textView.text == "")
    {
      textView.textColor = UIColor.lightGray
      textView.text = "\n\n\nMeal Description"
    }
  }
  
  // MARK: Touch Events
  func ratingLabelTapped(sender: UITapGestureRecognizer)
  {
    
    if (sender.state == UIGestureRecognizerState.ended)
    {
      let tapLocation = sender.location(in: detailRatingLabel)
      let ratingTap = Int(ceil((tapLocation.x/detailRatingLabel.frame.size.width) * 5 ))
      detailRatingLabel.text = starRating[ratingTap];
    }
  }
}
