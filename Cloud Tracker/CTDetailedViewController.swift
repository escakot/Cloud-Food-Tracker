//
//  CTDetailedViewController.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

protocol DetailedRatingDelegate: class {
  
  func updateMealRating(meal:Meal) -> Void
  
}

class CTDetailedViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  @IBOutlet weak var detailedImageView: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var detailRatingLabel: UILabel!
  @IBOutlet weak var caloriesLabel: UILabel!
  
  var meal: Meal!
  let starRating = ["☆☆☆☆☆", "★☆☆☆☆","★★☆☆☆", "★★★☆☆", "★★★★☆", "★★★★★"]
  weak var delegate:DetailedRatingDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    descriptionTextView.layer.borderColor = UIColor.gray.cgColor
    descriptionTextView.layer.borderWidth = 1.0
    
    let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ratingLabelTapped(sender:)))
    detailRatingLabel.addGestureRecognizer(tapGesture)
    detailRatingLabel.isUserInteractionEnabled = true
    
    let viewTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(imagePickerTap(sender:)))
    detailedImageView.isUserInteractionEnabled = true
    detailedImageView.addGestureRecognizer(viewTapGesture)
    
    navigationController!.navigationItem.title = meal.title!
    descriptionTextView.text = meal.mealDescription!
    caloriesLabel.text = String(format: "Calories: %li", meal.calories!)
    guard meal.rating != nil else {
      meal.rating = 0
      detailRatingLabel.text = starRating[0]
      return
    }
    detailRatingLabel.text = starRating[meal.rating!]
  }
  
  override func viewDidDisappear(_ animated: Bool)
  {
    meal.rating = starRating.index(of: detailRatingLabel.text!)
    delegate!.updateMealRating(meal: meal)
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
  
  func imagePickerTap(sender: UITapGestureRecognizer)
  {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
    imagePicker.delegate = self
    
    present(imagePicker, animated: true)
  }
}
