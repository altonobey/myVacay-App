//
//  CurrencyViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    // Object references to the UI objects instantiated in the Storyboard
    @IBOutlet var leftUpArrowBlack: UIImageView!
    @IBOutlet var rightUpArrowBlack: UIImageView!
    @IBOutlet var leftScrollMenu: UIScrollView!
    @IBOutlet var rightScrollMenu: UIScrollView!
    @IBOutlet var leftDownArrowBlack: UIImageView!
    @IBOutlet var rightDownArrowBlack: UIImageView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Create and initialize the array to store auto manufacturer names
    var countries = [String]()
    
    // fromCountryDataToPass is the data object to pass to the downstream view controller
    var fromCountryDataToPass = [String]()
    // toCountryDataToPass is the data object to pass to the downstream view controller
    var toCountryDataToPass = [String]()
    
    // Other properties (instance variables) and their initializations
    let kScrollMenuWidth: CGFloat = 124.0
    var selectedFromCountry = ""
    var selectedToCountry = ""
    var previousLeftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var previousRightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrencyData()
        
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        countries = applicationDelegate.dict_CountryName_CountryData.allKeys as! [String]
        
        // Sort the countries within itself in alphabetical order
        countries.sort { $0 < $1 }
        
        /***********************************************************************
         * Instantiate and setup the buttons for the vertically scrollable menu
         ***********************************************************************/
        
        // Instantiate a mutable array to hold the menu buttons to be created
        var leftListOfMenuButtons = [UIButton]()
        
        // Instantiate a mutable array to hold the menu buttons to be created
        var rightListOfMenuButtons = [UIButton]()
        
        for i in 0 ..< countries.count {
            
            // Instantiate a button to be placed within the vertically scrollable menu
            let leftScrollMenuButton = UIButton(type: UIButton.ButtonType.custom)
            let rightScrollMenuButton = UIButton(type: UIButton.ButtonType.custom)
            
            // Obtain the array of auto model names for the selected auto maker
            let dataForCountry = applicationDelegate.dict_CountryName_CountryData[countries[i]]
            
            // Convert the array to be a Swift array
            var countryDataList = dataForCountry! as! [String]
            
            // Obtain the country's flag image
            // Resize the country flag image to fit within the button
            var countryFlag = UIImage(named: "\(countryDataList[0].lowercased())")
            
            if (countryFlag == nil) {
                countryFlag = UIImage(named: "flagImageUnavailable.png")
            }
            
            let resizedFlagImage = resizeImage(image: countryFlag!, withSize: CGSize(width: 124, height: 50))
            
            // Set the button frame at origin at (x, y) = (0, 0) with
            // button width  = kScrollMenuWidth = 124
            // button height = 70 pixels
            leftScrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: kScrollMenuWidth, height: 70.0)
            rightScrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: kScrollMenuWidth, height: 70.0)
            
            // Set the button image to be the auto maker's logo
            leftScrollMenuButton.setImage(resizedFlagImage, for: UIControl.State())
            rightScrollMenuButton.setImage(resizedFlagImage, for: UIControl.State())
            
            // Obtain the title (i.e., auto manufacturer name) to be displayed on the button
            let leftButtonTitle = countries[i]
            let rightButtonTitle = countries[i]
            
            // The button width and height in points will depend on its font style and size
            let leftButtonTitleFont = UIFont(name: "Helvetica", size: 12.0)
            let rightButtonTitleFont = UIFont(name: "Helvetica", size: 12.0)
            
            // Set the font of the button title label text
            leftScrollMenuButton.titleLabel?.font = leftButtonTitleFont
            rightScrollMenuButton.titleLabel?.font = rightButtonTitleFont
            
            // Compute the size of the button title in points
            let leftButtonTitleSize: CGSize = (leftButtonTitle as NSString).size(withAttributes: [NSAttributedString.Key.font:leftButtonTitleFont!])
            let rightButtonTitleSize: CGSize = (rightButtonTitle as NSString).size(withAttributes: [NSAttributedString.Key.font:rightButtonTitleFont!])
            
            // Set the button title to the country's name
            leftScrollMenuButton.setTitle(countries[i], for: UIControl.State())
            rightScrollMenuButton.setTitle(countries[i], for: UIControl.State())
            
            // Set the button title color to black when the button is not selected
            leftScrollMenuButton.setTitleColor(UIColor.black, for: UIControl.State())
            rightScrollMenuButton.setTitleColor(UIColor.black, for: UIControl.State())
            
            // Set the button title color to red when the button is selected
            leftScrollMenuButton.setTitleColor(UIColor.red, for: UIControl.State.selected)
            rightScrollMenuButton.setTitleColor(UIColor.red, for: UIControl.State.selected)
            
            // Specify the Inset values for top, left, bottom, and right edges for the title
            leftScrollMenuButton.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -resizedFlagImage.size.width, bottom: -(resizedFlagImage.size.height + 5), right: 0.0)
            rightScrollMenuButton.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -resizedFlagImage.size.width, bottom: -(resizedFlagImage.size.height + 5), right: 0.0)
            
            // Specify the Inset values for top, left, bottom, and right edges for the country flag image
            leftScrollMenuButton.imageEdgeInsets = UIEdgeInsets.init(top: -(leftButtonTitleSize.height + 5), left: 0.0, bottom: 0.0, right: -leftButtonTitleSize.width)
            rightScrollMenuButton.imageEdgeInsets = UIEdgeInsets.init(top: -(rightButtonTitleSize.height + 5), left: 0.0, bottom: 0.0, right: -rightButtonTitleSize.width)
            
            // Set the button to invoke the buttonPressed: method when the user taps it
            leftScrollMenuButton.addTarget(self, action: #selector(CurrencyViewController.buttonPressed(_:)), for: .touchUpInside)
            rightScrollMenuButton.addTarget(self, action: #selector(CurrencyViewController.buttonPressed(_:)), for: .touchUpInside)
            
            // Add the constructed button to the list of buttons
            leftListOfMenuButtons.append(leftScrollMenuButton)
            rightListOfMenuButtons.append(rightScrollMenuButton)
        }
        
        /***********************************************************************************************
         * Compute the sumOfButtonHeights = sum of the heights of all buttons to be displayed in the menu
         ***********************************************************************************************/
        
        var sumOfLeftButtonHeights: CGFloat = 0.0
        var sumOfRightButtonHeights: CGFloat = 0.0
        
        for j in 0 ..< leftListOfMenuButtons.count {
            
            // Obtain the obj ref to the jth button in the listOfMenuButtons array
            let button: UIButton = leftListOfMenuButtons[j]
            
            // Set the button's frame to buttonRect
            var buttonRect: CGRect = button.frame
            
            // Set the buttonRect's y coordinate value to sumOfButtonHeights
            buttonRect.origin.y = sumOfLeftButtonHeights
            
            // Set the button's frame to the newly specified buttonRect
            button.frame = buttonRect
            
            // Add the button to the vertically scrollable menu
            leftScrollMenu.addSubview(button)
            
            // Add the height of the button to the total height
            sumOfLeftButtonHeights += button.frame.size.height
        }
        
        for j in 0 ..< rightListOfMenuButtons.count {
            
            // Obtain the obj ref to the jth button in the listOfMenuButtons array
            let button: UIButton = rightListOfMenuButtons[j]
            
            // Set the button's frame to buttonRect
            var buttonRect: CGRect = button.frame
            
            // Set the buttonRect's y coordinate value to sumOfButtonHeights
            buttonRect.origin.y = sumOfRightButtonHeights
            
            // Set the button's frame to the newly specified buttonRect
            button.frame = buttonRect
            
            // Add the button to the vertically scrollable menu
            rightScrollMenu.addSubview(button)
            
            // Add the height of the button to the total height
            sumOfRightButtonHeights += button.frame.size.height
        }
        
        // Vertically scrollable menu's content height size = the sum of the heights of all of the buttons
        // Vertically scrollable menu's content height size = kScrollMenuHeight points
        leftScrollMenu.contentSize = CGSize(width: kScrollMenuWidth, height: sumOfLeftButtonHeights)
        rightScrollMenu.contentSize = CGSize(width: kScrollMenuWidth, height: sumOfRightButtonHeights)
        
        /*******************************************************
         * Select and show the default auto maker upon app launch
         *******************************************************/
        
        // Hide left arrow
        leftUpArrowBlack.isHidden = true
        rightUpArrowBlack.isHidden = true
        
        // The first country on the list is the default one to display
        let defaultLeftButton: UIButton = leftListOfMenuButtons[0]
        let defaultRightButton: UIButton = rightListOfMenuButtons[0]
        
        // Indicate that the button is selected
        defaultLeftButton.isSelected = true
        defaultRightButton.isSelected = true
        
        previousLeftButton = defaultLeftButton
        previousRightButton = defaultRightButton
        
        selectedFromCountry = countries[0]
        selectedToCountry = countries[0]
    }
    
    func getCurrencyData() {
        // Define the API query URL to obtain company data for a given stock symbol
        let apiUrl = "https://free.currencyconverterapi.com/api/v5/countries"
        
        // Create a URL struct data structure from the API query URL string
        let url = URL(string: apiUrl)
        
        /*
         We use the NSData object constructor below to download the JSON data via HTTP in a single thread in this method.
         Downloading large amount of data via HTTP in a single thread would result in poor performance.
         For better performance, NSURLSession should be used.
         */
        
        // Declare jsonData as an optional of type Data
        let jsonData: Data?
        
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "Error!", messageBody: "No Top News Found!")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            
            do {
                /*
                 JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
                 JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfCurrenciesJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                
                let results = dictionaryOfCurrenciesJsonData["results"] as! Dictionary<String, AnyObject>
                //let sortedResults = results.sorted(by: { $0.key < $1.key })
                
                for (_,value) in results {
                    let country = value as! [String:AnyObject]
                    
                    let countryData = [country["id"], country["currencyName"], country["currencyId"], country["currencySymbol"]]
                    /*
                     --------------------------------------------------------------
                     Add the created array the country to the dictionary
                     dict_CountryName_CountryData held by the app delegate object.
                     --------------------------------------------------------------
                     */
                    applicationDelegate.dict_CountryName_CountryData.setObject(countryData, forKey: country["name"] as! NSCopying)
                }
                
                countries = applicationDelegate.dict_CountryName_CountryData.allKeys as! [String]
                
                // Sort the stock symbols within itself in alphabetical order
                countries.sort { $0 < $1 }
                
            } catch let error as NSError {
                
                showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")
                return
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
    }
    
    /*
     -----------------------------------
     MARK: - Method to Handle Button Tap
     -----------------------------------
     */
    // This method is invoked when the user taps a button in the vertically scrollable menu
    @objc func buttonPressed(_ sender: UIButton) {
        
        if sender.superview?.tag == 0 {
            let leftSelectedButton: UIButton = sender
            
            // Indicate that the button is selected
            leftSelectedButton.isSelected = true
            
            if previousLeftButton != leftSelectedButton {
                // Selecting the selected button again should not change its title color
                previousLeftButton.isSelected = false
            }
            
            previousLeftButton = leftSelectedButton
            selectedFromCountry = leftSelectedButton.title(for: UIControl.State())!
            
        } else if sender.superview?.tag == 1 {
            let rightSelectedButton: UIButton = sender
            
            // Indicate that the button is selected
            rightSelectedButton.isSelected = true
            
            if previousRightButton != rightSelectedButton {
                // Selecting the selected button again should not change its title color
                previousRightButton.isSelected = false
            }
            
            previousRightButton = rightSelectedButton
            selectedToCountry = rightSelectedButton.title(for: UIControl.State())!
        }
    }
    
    /*
     -----------------------------------
     MARK: - Scroll View Delegate Method
     -----------------------------------
     */
    
    // Tells the delegate when the user scrolls the content view within the receiver
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
         Content        = concatenated list of buttons
         Content Height = sum of all button heights, sumOfButtonHeights
         Content Width  = kScrollMenuWidth points
         Origin         = (x, y) values of the bottom left corner of the scroll view or content
         Sy             = Scroll View's origin y value
         Cy             = Content's origin y value
         contentOffset  = Cy - Sy
         
         Interpretation of the Arrows:
         
         IF scrolled all the way to the BOTTOM then show only DOWN arrow: indicating that the data (content) is
         on the lower side and therefore, the user must *** scroll UP *** to see the content.
         
         IF scrolled all the way to the TOP then show only UP arrow: indicating that the data (content) is
         on the upper side and therefore, the user must *** scroll DOWN *** to see the content.
         
         5 pixels used as padding
         */
        if (scrollView == leftScrollMenu) {
            if scrollView.contentOffset.y <= 5 {
                // Scrolling is done all the way to the BOTTOM
                leftUpArrowBlack.isHidden   = true      // Hide Up arrow
                leftDownArrowBlack.isHidden  = false    // Show Down arrow
            }
            else if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 5 {
                // Scrolling is done all the way to the TOP
                leftUpArrowBlack.isHidden   = false     // Show Up arrow
                leftDownArrowBlack.isHidden  = true     // Hide Down arrow
            }
            else {
                // Scrolling is in between. Scrolling can be done in either direction.
                leftUpArrowBlack.isHidden   = false     // Show Up arrow
                leftDownArrowBlack.isHidden  = false    // Show Down arrow
            }
        } else {
            if scrollView.contentOffset.y <= 5 {
                // Scrolling is done all the way to the BOTTOM
                rightUpArrowBlack.isHidden   = true      // Hide Up arrow
                rightDownArrowBlack.isHidden  = false    // Show Down arrow
            }
            else if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 5 {
                // Scrolling is done all the way to the TOP
                rightUpArrowBlack.isHidden   = false     // Show Up arrow
                rightDownArrowBlack.isHidden  = true     // Hide Down arrow
            }
            else {
                // Scrolling is in between. Scrolling can be done in either direction.
                rightUpArrowBlack.isHidden   = false     // Show Up arrow
                rightDownArrowBlack.isHidden  = false    // Show Down arrow
            }
        }
    }
    
    /*
     ------------------------------------
     MARK: - Resize Image Proportionately
     ------------------------------------
     */
    func resizeImage(image: UIImage, withSize: CGSize) -> UIImage {
        
        var actualHeight: CGFloat = image.size.height
        var actualWidth: CGFloat = image.size.width
        let maxHeight: CGFloat = withSize.width
        let maxWidth: CGFloat = withSize.height
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        let compressionQuality = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                // Adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if (imgRatio > maxRatio) {
                // Adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let image: UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        //let imageData = UIImageJPEGRepresentation(image, CGFloat(compressionQuality))
        let imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        let resizedImage = UIImage(data: imageData!)
        
        return resizedImage!
    }
    
    // This method is invoked when the Next button is tapped
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        countries = applicationDelegate.dict_CountryName_CountryData.allKeys as! [String]
        
        // Sort the countries within itself in alphabetical order
        countries.sort { $0 < $1 }
        
        // Obtain the array of auto model names for the selected auto maker
        let dataForFromCountry = applicationDelegate.dict_CountryName_CountryData[selectedFromCountry]
        let dataForToCountry = applicationDelegate.dict_CountryName_CountryData[selectedToCountry]
        
        // Convert the array to be a Swift array
        var fromCountryDataList = dataForFromCountry! as! [String]
        var toCountryDataList = dataForToCountry! as! [String]
        
        // Set the API URL to obtain the JSON file containing the stock quote for the stock symbol entered
        let apiUrl = "https://free.currencyconverterapi.com/api/v5/convert?q=\(fromCountryDataList[2])_\(toCountryDataList[2]),\(toCountryDataList[2])_\(fromCountryDataList[2])&compact=ultra"
        
        // Create a URL struct data structure from the API URL string
        let url = URL(string: apiUrl)
        
        /*
         We use the Data object constructor below to download the JSON data via HTTP in a single thread in this method.
         Downloading large amount of data via HTTP in a single thread would result in poor performance.
         For better performance, NSURLSession should be used.
         */
        
        let jsonData: Data?
        
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: Data.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "Currency Ids Unrecognized!", messageBody: "No countries found for the currency Ids \(fromCountryDataList[2]) or \(toCountryDataList[2])!")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            
            do {
                /*
                 JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
                 JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl,
                                                                          options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfCompanyJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                //***************************
                // Obtain From-To Conversion
                //***************************
                
                var fromTo = ""
                
                if let fromToConv = dictionaryOfCompanyJsonData["\(fromCountryDataList[2])_\(toCountryDataList[2])"] as! Double? {
                    fromTo = String(fromToConv)
                } else {
                    fromTo = "Unable to obtain!"
                }
                
                //***************************
                // Obtain To-From Conversion
                //***************************
                
                var toFrom = ""
                
                if let toFromConv = dictionaryOfCompanyJsonData["\(toCountryDataList[2])_\(fromCountryDataList[2])"] as! Double? {
                    toFrom = String(toFromConv)
                } else {
                    toFrom = "Unable to obtain!"
                }
                
                //***************************************************
                // Create an array containing all of the company data
                //***************************************************
                
                fromCountryDataToPass = fromCountryDataList
                fromCountryDataToPass.append(selectedFromCountry)
                fromCountryDataToPass.append(fromTo)
                toCountryDataToPass = toCountryDataList
                toCountryDataToPass.append(selectedToCountry)
                toCountryDataToPass.append(toFrom)
                
                /*
                 fromCountryDataToPass[0] = Country Code
                 fromCountryDataToPass[1] = Currency Name
                 fromCountryDataToPass[2] = Currency Id
                 fromCountryDataToPass[3] = Currency Symbol
                 fromCountryDataToPass[4] = Country Name
                 fromCountryDataToPass[5] = From-To Conversion
                 */
                
                /*
                 toCountryDataToPass[0] = Country Code
                 toCountryDataToPass[1] = Currency Name
                 toCountryDataToPass[2] = Currency Id
                 toCountryDataToPass[3] = Currency Symbol
                 toCountryDataToPass[4] = Country Name
                 toCountryDataToPass[5] = To-From Conversion
                 */
                
                performSegue(withIdentifier: "ShowConverter", sender: self)
                
            } catch let error as NSError {
                
                showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")
                return
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
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
        
        if segue.identifier == "ShowConverter" {
            
            // Obtain the object reference of the destination view controller
            let converterViewController: ConverterViewController = segue.destination as! ConverterViewController
            
            // Pass the data object to the downstream view controller object
            converterViewController.fromDataPassed = fromCountryDataToPass
            // Pass the data object to the downstream view controller object
            converterViewController.toDataPassed = toCountryDataToPass
        }
    }

}
