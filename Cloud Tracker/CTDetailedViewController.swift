//
//  CTDetailedViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class CTDetailedViewController: UIViewController, UITextViewDelegate {

  
  @IBOutlet weak var detailedImageView: UIImageView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var detailRatingLabel: UILabel!
  
  var meal: Meal!
  let starRating = ["☆☆☆☆☆", "★☆☆☆☆","★★☆☆☆", "★★★☆☆", "★★★★☆", "★★★★★"]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      descriptionTextView.layer.borderColor = UIColor.gray.cgColor
      descriptionTextView.layer.borderWidth = 1.0
      
      let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ratingLabelTapped(sender:)))
      detailRatingLabel.addGestureRecognizer(tapGesture)
      detailRatingLabel.isUserInteractionEnabled = true
      
      titleTextField.text = meal.title!
      descriptionTextView.text = meal.mealDescription!
      guard meal.rating != nil else {
        detailRatingLabel.text = starRating[0]
        return
      }
      detailRatingLabel.text = starRating[meal.rating!]
      
      if (descriptionTextView.text == "")
      {
        descriptionTextView.text = "\n\n\n\nMeal Description"
        descriptionTextView.textColor = UIColor.lightGray
      }
    }
  
  // MARK: TextView Delegate
  func textViewDidBeginEditing(_ textView: UITextView) {
    if (textView.text == "\n\n\n\nMeal Description")
    {
      textView.textColor = UIColor.black
      textView.text = ""
    } else if (textView.text == "")
    {
      textView.textColor = UIColor.lightGray
      textView.text = "\n\n\n\nMeal Description"
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
