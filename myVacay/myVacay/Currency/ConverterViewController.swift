//
//  ConverterViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {

    // Instance variable holding the object reference of the TextField UI object created in the Storyboard
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var fromCountryFlagImageView: UIImageView!
    @IBOutlet var fromCountryNameTitleLabel: UILabel!
    @IBOutlet var fromCurrencyNameTitleLabel: UILabel!
    @IBOutlet var fromCurrencyIDTitleLabel: UILabel!
    @IBOutlet var fromCurrencySymbolTitleLabel: UILabel!
    @IBOutlet var toCountryFlagImageView: UIImageView!
    @IBOutlet var toCountryNameTitleLabel: UILabel!
    @IBOutlet var toCurrencyNameTitleLabel: UILabel!
    @IBOutlet var toCurrencyIDTitleLabel: UILabel!
    @IBOutlet var toCurrencySymbolTitleLabel: UILabel!
    @IBOutlet var convertedAmountTitleLabel: UILabel!
    
    // fromDataPassed is set by the upstream view controller
    var fromDataPassed = [String]()
    // toDataPassed is set by the upstream view controller
    var toDataPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set From Country Flag Image
        let fromImage = UIImage(named: "\(fromDataPassed[0].lowercased())")
        
        if (fromImage == nil) {
            fromCountryFlagImageView!.image = UIImage(named: "flagImageUnavailable.png")
        } else {
            fromCountryFlagImageView!.image = fromImage
        }
        
        // Set From Country Name
        fromCountryNameTitleLabel!.text = fromDataPassed[4]
        
        // Set From Currency Name
        fromCurrencyNameTitleLabel!.text = fromDataPassed[1]
        
        // Set From Currency ID
        fromCurrencyIDTitleLabel!.text = fromDataPassed[2]
        
        // Set From Currency Symbol
        fromCurrencySymbolTitleLabel!.text = fromDataPassed[3]
        
        
        // Set To Country Flag Image
        let toImage = UIImage(named: "\(toDataPassed[0].lowercased())")
        
        if (toImage == nil) {
            toCountryFlagImageView!.image = UIImage(named: "flagImageUnavailable.png")
        } else {
            toCountryFlagImageView!.image = toImage
        }
        
        // Set To Country Name
        toCountryNameTitleLabel!.text = toDataPassed[4]
        
        // Set From Currency Name
        toCurrencyNameTitleLabel!.text = toDataPassed[1]
        
        // Set From Currency ID
        toCurrencyIDTitleLabel!.text = toDataPassed[2]
        
        // Set From Currency Symbol
        toCurrencySymbolTitleLabel!.text = toDataPassed[3]
    }
    
    /*
     -----------------------------------
     MARK: - Switch Currencies
     -----------------------------------
     */
    
    // This method plays the turkey gobble sound if the detected motion is a Shake Gesture
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        var temp = [String]()
        temp = fromDataPassed
        fromDataPassed = toDataPassed
        toDataPassed = temp
        viewDidLoad()
        let amount: String  = amountTextField.text!
        let characterset = CharacterSet(charactersIn: ".0123456789")
        if (amount == "" || amount.rangeOfCharacter(from: characterset.inverted) != nil) {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a number value as currency amount!")
        } else {
            let convertedAmount = Double(Double(amount)! * Double(fromDataPassed[5])!)
            convertedAmountTitleLabel.text = String(Double(round(100000000*convertedAmount)/100000000))
        }
    }
    
    // This method is invoked when the convert button is tapped
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        let amount: String  = amountTextField.text!
        let characterset = CharacterSet(charactersIn: ".0123456789")
        if (amount == "" || amount.rangeOfCharacter(from: characterset.inverted) != nil) {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a number value as currency amount!")
        } else {
            let convertedAmount = Double(Double(amount)! * Double(fromDataPassed[5])!)
            convertedAmountTitleLabel.text = String(Double(round(100000000*convertedAmount)/100000000))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
         ---------------------------------------------------------------------
         Force this view to be displayed first in Portrait device orientation.
         However, the user can override this by manually rotating the device.
         ---------------------------------------------------------------------
         */
        let portraitValue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(portraitValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
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

}
