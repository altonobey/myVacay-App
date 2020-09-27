//
//  RestaurantTableViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/10/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurantTableViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet var restaurantsTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var foodType = ""
    var latitude = ""
    var longitude = ""
    var sortBy: YelpSortMode = YelpSortMode.best_match
    var openNow: Bool = false
    var addressToPass = ""
    var restaurantNameToPass = ""
    var latitudeToPass: Double?
    var longitudeToPass: Double?
    
    // searchDataPassed is set by the upstream view controller
    var searchDataPassed: [String]!
    
    var businesses: [Business]!
    
    let tableViewRowHeight: CGFloat = 102.0
    
    // Alternate table view rows have a background color of MintCream or OldLace for clarity of display
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if (searchDataPassed[1] == "Best Match") {
            sortBy = YelpSortMode.best_match
        } else if (searchDataPassed[1] == "Distance") {
            sortBy = YelpSortMode.distance
        } else if (searchDataPassed[1] == "Rating") {
            sortBy = YelpSortMode.rating
        } else {
            sortBy = YelpSortMode.review_count
        }
        
        if (searchDataPassed[2] == "true") {
            openNow = true
        } else {
            openNow = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latitude = String(locValue.latitude)
        self.longitude = String(locValue.longitude)
        
        Business.searchWithTerm(term: searchDataPassed[0], location: "\(latitude),\(longitude)", sort: sortBy, categories: [], openNow: openNow, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.restaurantsTableView.reloadData()
        }
        )
    }
    
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (businesses.count == 0) {
            showAlertMessage(messageHeader: "No Restaurants Found", messageBody: "Please change your preferences and try again!")
        }
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // Top News Cell, which was specified in the storyboard
        let cell: RestaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Restaurants Cell") as! RestaurantTableViewCell
        
        // Set Top News Description
        cell.business = businesses[rowNumber]
        
        return cell
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    //---------------------------------
    // Selection of a Restaurant (Row)
    //---------------------------------
    
    // Tapping a row (restaurant) displays the restaurant on a map
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        addressToPass = businesses[rowNumber].address!
        restaurantNameToPass = businesses[rowNumber].name!
        
        //******************
        // Forward Geocoding
        //******************
        
        // Instantiate a forward geocoder object
        let forwardGeocoder = CLGeocoder()
        
        /*
         Ask the forward geocoder object to
         (a) execute its geocodeAddressString method in a new thread *** asynchronously ***
         (b) determine the geolocation (latitude, longitude) of the given address, and
         (c) give the results to the completion handler function geocoderCompletionHandler running under the main thread.
         */
        forwardGeocoder.geocodeAddressString(addressToPass) { (placemarks, error) in
            self.geocoderCompletionHandler(withPlacemarks: placemarks, error: error)
        }
        
        /*
         "This method submits the specified location data to the geocoding server asynchronously and returns.
         Your completion handler block [i.e., our geocoderCompletionHandler() function] will be executed on the main thread.
         After initiating a forward-geocoding request, do not attempt to initiate another forward- or reverse-geocoding request.
         
         Geocoding requests are rate-limited for each app, so making too many requests in a short period of time
         may cause some of the requests to fail. When the maximum rate is exceeded, the geocoder passes an error object
         with the value network to your completion handler." [Apple]
         
         Due to the asynchronous processing nature, statements after this method may not be executed.
         Therefore, we have to include the performSegue method at the end of the completion handler block.
         *** If you put the performSegue method right here, the code will fail because of asynchronous processing. ***
         */
    }
    
    /*
     ---------------------------------
     MARK: - Process Geocoding Results
     ---------------------------------
     */
    private func geocoderCompletionHandler(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let errorOccurred = error {
            self.showAlertMessage(messageHeader: "Forward Geocoding Unsuccessful!",
                                  messageBody: "Forward Geocoding of the Given Address Failed: (\(errorOccurred))")
            return
        }
        
        var geolocation: CLLocation?
        
        if let placemarks = placemarks, placemarks.count > 0 {
            geolocation = placemarks.first?.location
        }
        
        if let locationObtained = geolocation {
            
            self.latitudeToPass = locationObtained.coordinate.latitude
            self.longitudeToPass = locationObtained.coordinate.longitude
            
        } else {
            self.showAlertMessage(messageHeader: "Location Match Failed!",
                                  messageBody: "Unable to Find a Matching Location!")
            return
        }
        
        // Perform the segue named Directions
        performSegue(withIdentifier: "Directions", sender: self)
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    /*
     Informs the table view delegate that the table view is about to display a cell for a particular row.
     Just before the cell is displayed, we change the cell's background color as MINT_CREAM for even-numbered rows
     and OLD_LACE for odd-numbered rows to improve the table view's readability.
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /*
         The remainder operator (RowNumber % 2) computes how many multiples of 2 will fit inside RowNumber
         and returns the value, either 0 or 1, that is left over (known as the remainder).
         Remainder 0 implies even-numbered rows; Remainder 1 implies odd-numbered rows.
         */
        if indexPath.row % 2 == 0 {
            // Set even-numbered row's background color to MintCream, #F5FFFA 245,255,250
            cell.backgroundColor = MINT_CREAM
            
        } else {
            // Set odd-numbered row's background color to OldLace, #FDF5E6 253,245,230
            cell.backgroundColor = OLD_LACE
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Directions" {
            
            // Obtain the object reference of the destination view controller
            let restaurantMapViewController: RestaurantMapViewController = segue.destination as! RestaurantMapViewController
            // Pass the data object to the downstream view controller object
            restaurantMapViewController.latitudePassed = latitudeToPass
            restaurantMapViewController.longitudePassed = longitudeToPass
            restaurantMapViewController.restaurantName = restaurantNameToPass
        }
    }
}
