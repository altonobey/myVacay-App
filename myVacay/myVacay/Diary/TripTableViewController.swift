//
//  TripTableViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Nolan Turley. All rights reserved.
//

import UIKit

class TripTableViewController: UITableViewController {

    @IBOutlet var tripTableView: UITableView!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableViewRowHeight: CGFloat = 100.0
    
    // Alternate table view rows have a background color of MintCream or OldLace for clarity of display
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    //---------- Create and Initialize the Arrays -----------------------
    var tripInfoArray = [String]()
    
    var TripDataToPass = [String]()
    
    var activity = ActivityIndicator(text: "Loading Result")
    var tripName = ""
    var tripDescription = ""
    var tripLocation = ""
    var imageLocation =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addVideo method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                         action: #selector(TripTableViewController.addTrip(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        tripInfoArray = applicationDelegate.dict_TripID_TripData.allKeys as! [String]
        
        // Sort the videoIDs within itself in alphabetical order
        tripInfoArray.sort { $0 < $1 }
        
    }
    
    @objc func addTrip(_ sender: AnyObject) {
        // Perform the segue
        performSegue(withIdentifier: "addTrip", sender: self)
    }

    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToTripTableViewController(segue : UIStoryboardSegue) {
        
        if segue.identifier != "saveTrip" {
            return
        }
        
        
        // Obtain the object reference of the source view controller
        let AddTripViewController: AddTripViewController = segue.source as! AddTripViewController
        
        var numOfKeys = applicationDelegate.dict_TripID_TripData.count + 1
        if (applicationDelegate.dict_TripID_TripData.count == 0) {
            numOfKeys = 0
        }
        
        
        if (AddTripViewController.tripName.text?.isEmpty ?? true){
            //showAlertMessage(messageHeader: "Trip Name Required!", messageBody: "Please enter a name for the trip!")
            tripName = ""
        } else {
            tripName = AddTripViewController.tripName.text!
        }
        
        if (AddTripViewController.tripDescription.text?.isEmpty ?? true){
            tripDescription = ""
        } else {
            tripDescription = AddTripViewController.tripDescription.text!
        }
        
        if (AddTripViewController.tripLocation.text?.isEmpty ?? true){
            tripLocation = ""
        } else {
            tripLocation = AddTripViewController.tripLocation.text!
        }
        
        if (AddTripViewController.imageLocation.isEmpty){
            imageLocation =  ""
        } else {
            imageLocation = AddTripViewController.imageLocation
        }
        
        if (tripName == "" && tripDescription == "" && tripLocation == "" && imageLocation == "") {
            showAlertMessage(messageHeader: "No Note Data", messageBody: "Please add at lease one piece of data and try again!")
            return
        }
        
        let dateObject = AddTripViewController.tripDate!
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let theDate = formatter.string(from: dateObject.date)
        
        
        let TripDataObtained = [tripName, tripLocation, theDate, tripDescription, imageLocation]
        
        
        applicationDelegate.dict_TripID_TripData.setObject(TripDataObtained, forKey: String(numOfKeys) as NSCopying)
        
        tripInfoArray = applicationDelegate.dict_TripID_TripData.allKeys as! [String]
        
        // Sort the array within itself in alphabetical order
        tripInfoArray.sort { $0 < $1 }
        
        /*
         --------------------------
         5. Update tripTableView
         --------------------------
         */
        tripTableView.reloadData()
        
        
    }
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // We have only one section in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tripInfoArray.count
    }
    
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.view.addSubview(self.activity)
        
        let rowNumber = (indexPath as NSIndexPath).row
  
        let cell: TripTableViewCell = tableView.dequeueReusableCell(withIdentifier: "trip") as! TripTableViewCell
    
        let givenTripID = tripInfoArray[rowNumber]

        let DataObtained: AnyObject? = applicationDelegate.dict_TripID_TripData[givenTripID] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var tripDataForCell = DataObtained! as! [String]
        
        
        let logoImageData = tripDataForCell[4]
        cell.tripImage!.image = UIImage(named: logoImageData)
        if ( UIImage(named: logoImageData) == nil ){
           cell.tripImage!.image = UIImage(named: "NoImageAvailable.png")
        }
        
        cell.tripDate!.text = tripDataForCell[2]
        cell.tripLocation!.text = tripDataForCell[1]
        cell.tripName!.text = tripDataForCell[0]
        
        self.activity.hide()
        return cell
    }
    
    //-------------------------------
    // Allow Editing of Rows
    //-------------------------------
    
    // We allow each row of the table view to be editable, i.e., deletable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    // This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {   // Handle the Delete action
            
            let rowNumber = (indexPath as NSIndexPath).row
            
            // Obtain the videoID of the selected video
            let selectedID = tripInfoArray[rowNumber]
            
            applicationDelegate.dict_TripID_TripData.removeObject(forKey: selectedID)
            
            tripInfoArray = applicationDelegate.dict_TripID_TripData.allKeys as! [String]
            
            // Sort the videoID within itself in alphabetical order
            tripInfoArray.sort { $0 < $1 }
            
            // Reload the Table View
            tripTableView.reloadData()
        }
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
    
    // Tapping a row displays data about the selected video
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        let selectedVideoID = tripInfoArray[rowNumber]
        
        let videoDataObtained: AnyObject? = applicationDelegate.dict_TripID_TripData[selectedVideoID] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        TripDataToPass = videoDataObtained! as! [String]
        
        TripDataToPass.append(selectedVideoID)
        
        performSegue(withIdentifier: "tripInfo", sender: self)
    }
    
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "tripInfo" {
            
            //Obtain the object reference of the destination view controller
            let TripDetailsViewController: TripDetailsViewController = segue.destination as! TripDetailsViewController
            
            
            TripDetailsViewController.tripDataPassed = TripDataToPass
            
            
        }
    }
    
    
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
    
}
