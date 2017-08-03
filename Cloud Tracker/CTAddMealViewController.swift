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

class CTAddMealViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var addImageView: UIImageView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var addRatingLabel: UILabel!
  @IBOutlet weak var caloriesTextField: UITextField!
  
  let starRating = ["☆☆☆☆☆", "★☆☆☆☆","★★☆☆☆", "★★★☆☆", "★★★★☆", "★★★★★"]
  weak var delegate:AddMealDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    descriptionTextView.layer.borderColor = UIColor.gray.cgColor
    descriptionTextView.layer.borderWidth = 1.0
    
    let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ratingLabelTapped(sender:)))
    addRatingLabel.isUserInteractionEnabled = true
    addRatingLabel.addGestureRecognizer(tapGesture)
    
    let viewTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(imagePickerTap(sender:)))
    addImageView.isUserInteractionEnabled = true
    addImageView.addGestureRecognizer(viewTapGesture)
    
    addRatingLabel.text = starRating[0]
    
    descriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
    descriptionTextView.layer.borderWidth = 1.0
    descriptionTextView.textColor = UIColor.lightGray
    descriptionTextView.delegate = self
  }
  
  @IBAction func saveButton(_ sender: UIBarButtonItem) {
    let meal = Meal()
    meal.title = titleTextField.text
    meal.mealDescription = descriptionTextView.text
    meal.calories = Int(caloriesTextField.text!)
    meal.rating = starRating.index(of: addRatingLabel.text!)
    if (addImageView.image != nil)
    {
      meal.imageData = UIImageJPEGRepresentation(addImageView.image!, 1.0)
    }
    
    delegate!.addMeal(meal: meal)
    dismiss(animated: true)
  }
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  
  // MARK: Touch Events
  func ratingLabelTapped(sender: UITapGestureRecognizer)
  {
    
    if (sender.state == UIGestureRecognizerState.ended)
    {
      let tapLocation = sender.location(in: addRatingLabel)
      let ratingTap = Int(ceil((tapLocation.x/addRatingLabel.frame.size.width) * 5 ))
      addRatingLabel.text = starRating[ratingTap];
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
  
  // MARK: UIPickerController Delegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
  {
    if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      addImageView.image = pickedImage
    } else {
      print("Image error")
    }
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
}
