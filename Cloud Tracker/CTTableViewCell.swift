//
//  CTTableViewCell.swift
//  Cloud Tracker
//
//  Created by Errol Cheong on 2017-07-31.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

import UIKit

class CTTableViewCell: UITableViewCell {

  
  @IBOutlet weak var cellImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var starRatingLabel: UILabel!
  
  let starRating = ["☆☆☆☆☆", "★☆☆☆☆","★★☆☆☆", "★★★☆☆", "★★★★☆", "★★★★★"]
  
  var meal : Meal! {
    didSet {
      if meal.imagePath != nil {
        do { cellImageView.image = try UIImage(data: Data(contentsOf: URL.init(string: meal.imagePath!)!))
        } catch {
          print(error.localizedDescription)
        }
      }
      titleLabel.text = meal.title!
      guard meal.rating != nil  else {
        starRatingLabel.text = starRating[0]
        return
      }
      starRatingLabel.text = starRating[meal.rating!]
    }
  }

}
