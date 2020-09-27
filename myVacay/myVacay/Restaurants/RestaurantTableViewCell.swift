//
//  RestaurantTableViewCell.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/10/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var restaurantImageVIew: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var reviewsCount: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            restaurantImageVIew.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCount.text = "\(business.reviewCount!) Reviews"
            //print(business.ratingImage?.description as Any)
            //ratingImageView.image = UIImage(data: business!.ratingImage.des)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
