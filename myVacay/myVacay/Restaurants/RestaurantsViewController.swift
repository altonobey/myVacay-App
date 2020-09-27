//
//  RestaurantsViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/10/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit

class RestaurantsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var foodType: UITextField!
    @IBOutlet var sortBy: UIPickerView!
    @IBOutlet var openNow: UISegmentedControl!
    
    var sortByData = ["Best Match", "Distance", "Rating", "Review Count"]
    var type = ""
    var sort = ""
    var open = ""
    
    // searchDataToPass is the data object to pass to the downstream view controller
    var searchDataToPass = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortByData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortByData[row]
    }

    @IBAction func openNowSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0:   // Open Now
            open = "true"
        case 1:   // Not Open Now
            open = "false"
        default:
            return
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        type = foodType.text!
        sort = sortByData[sortBy.selectedRow(inComponent: 0)]
        
        performSegue(withIdentifier: "Results", sender: self)
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
     ------------------------
     MARK: - IBAction Methods
     ------------------------
     */
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         When the Text Field resigns as first responder, the keyboard is automatically removed.
         */
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Results" {
            let restaurantTableViewController: RestaurantTableViewController = segue.destination as! RestaurantTableViewController
            searchDataToPass.removeAll()
            if (type == "") {
                showAlertMessage(messageHeader: "No Food Type Entered!",
                                 messageBody: "Please enter a food type and try again!")
                return
            } else if (sort == "") {
                showAlertMessage(messageHeader: "No Sort By Picked!",
                                 messageBody: "Please pick a sort by and try again!")
                return
            } else if (open == "") {
                showAlertMessage(messageHeader: "No Open Now Selected!",
                                 messageBody: "Please select an open or closed and try again!")
                return
            }
            searchDataToPass.append(type)
            searchDataToPass.append(sort)
            searchDataToPass.append(open)
            restaurantTableViewController.searchDataPassed = searchDataToPass
        }
    }
}
