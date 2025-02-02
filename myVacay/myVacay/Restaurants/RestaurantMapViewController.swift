//
//  RestaurantMapViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/10/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurantMapViewController: UIViewController {

    // Instance variable holding the object reference of the MKMapView object created in the Storyboard
    @IBOutlet var mapView: MKMapView!
    
    // Data set by upstream view controller GeocodingViewController
    var restaurantName = ""
    var latitudePassed: Double?
    var longitudePassed: Double?
    
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 804.672    // = 0.5 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 804.672   // = 0.5 mile
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--------------------------------------------------
        // Adjust the title to fit within the navigation bar
        //--------------------------------------------------
        
        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
        let titleLabel = UILabel(frame: labelRect)
        
        titleLabel.text = restaurantName
        
        titleLabel.font = titleLabel.font.withSize(12)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
        
        //-----------------------------
        // Dress up the map view object
        //-----------------------------
        
        mapView.mapType = MKMapType.hybrid
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = false
        
        // Address Center Geolocation
        let addressCenterLocation = CLLocationCoordinate2D(latitude: latitudePassed!, longitude: longitudePassed!)
        
        // Define map's visible region
        let addressMapRegion: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation, latitudinalMeters: latitudinalSpanInMeters, longitudinalMeters: longitudinalSpanInMeters)
        
        // Set the mapView to show the defined visible region
        mapView.setRegion(addressMapRegion!, animated: true)
        
        //*************************************
        // Prepare and Set Address Annotation
        //*************************************
        
        // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
        let annotation = MKPointAnnotation()
        
        // Dress up the newly created MKPointAnnotation() object
        annotation.coordinate = addressCenterLocation
        annotation.title = restaurantName
        annotation.subtitle = ""
        
        // Add the created and dressed up MKPointAnnotation() object to the map view
        mapView.addAnnotation(annotation)
    }

}
