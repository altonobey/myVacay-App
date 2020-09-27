//
//  TripImageViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Nolan Turley. All rights reserved.
//

import UIKit

class TripImageViewController: UIViewController {

    var imageNamePassed = UIImage(named: "")
    
    @IBOutlet var tripImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tripImage.image = imageNamePassed
        
    }
}
