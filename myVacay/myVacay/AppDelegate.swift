//
//  AppDelegate.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Instance variable to hold the object reference of a Dictionary object, the content of which is modifiable at runtime
    var dict_CountryName_CountryData: NSMutableDictionary = NSMutableDictionary()
    var dict_TripID_TripData: NSMutableDictionary = NSMutableDictionary()
    var dict_Lang_Id: NSMutableDictionary = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyB0OD0XQ9UQq85DBAEVg7Fbg0C0nxJuZs8")
        
        /*
         All application-specific and user data must be written to files that reside in the iOS device's
         Document directory. Nothing can be written into application's main bundle (project folder) because
         it is locked for writing after your app is published.
         
         The contents of the iOS device's Document directory are backed up by iTunes during backup of an iOS device.
         Therefore, the user can recover the data written by your app from an earlier device backup.
         
         The Document directory path on an iOS device is different from the one used for the iOS Simulator.
         
         To obtain the Document directory path, you use the NSSearchPathForDirectoriesInDomains function.
         However, this function was created originally for Mac OS, where multiple such directories could exist.
         Therefore, it returns an array of paths rather than a single path.
         
         For iOS, the resulting array's first element (index=0) contains the path to the Document directory.
         */
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/Countries.plist"
        
        /*
         NSMutableDictionary manages an *unordered* collection of mutable (modifiable) key-value pairs.
         Instantiate an NSMutableDictionary object and initialize it with the contents of the Countries.plist file.
         */
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        /*
         IF the optional variable dictionaryFromFile has a value, THEN
         Countries.plist exists in the Document directory and the dictionary is successfully created
         ELSE read Countries.plist from the application's main bundle.
         */
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            
            // Countries.plist exists in the Document directory
            dict_CountryName_CountryData = dictionaryFromFileInDocumentDirectory
            
        } else {
            
            // Countries.plist does not exist in the Document directory; Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "Countries", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the Countries.plist file.
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            dict_CountryName_CountryData = dictionaryFromFileInMainBundle!
        }
        
        let paths1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath1 = paths1[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory1 = documentDirectoryPath1 + "/MyTrips.plist"
        
        let dictionaryFromFile1: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory1)
        
        if let dictionaryFromFileInDocumentDirectory1 = dictionaryFromFile1 {
            
            dict_TripID_TripData = dictionaryFromFileInDocumentDirectory1
            
        } else {
            
            let plistFilePathInMainBundle1 = Bundle.main.path(forResource: "MyTrips", ofType: "plist")
            
            let dictionaryFromFileInMainBundle1: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle1!)
            
            
            dict_TripID_TripData = dictionaryFromFileInMainBundle1!
        }
        
        let paths2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath2 = paths2[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory2 = documentDirectoryPath2 + "/Languages.plist"
        
        let dictionaryFromFile2: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory2)
        
        if let dictionaryFromFileInDocumentDirectory2 = dictionaryFromFile2 {
            
            dict_Lang_Id = dictionaryFromFileInDocumentDirectory2
            
        } else {
            
            let plistFilePathInMainBundle2 = Bundle.main.path(forResource: "Languages", ofType: "plist")
            
            let dictionaryFromFileInMainBundle2: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle2!)
            
            
            dict_Lang_Id = dictionaryFromFileInMainBundle2!
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        /*
         "UIApplicationWillResignActiveNotification is posted when the app is no longer active and loses focus.
         An app is active when it is receiving events. An active app can be said to have focus.
         It gains focus after being launched, loses focus when an overlay window pops up or when the device is
         locked, and gains focus when the device is unlocked." [Apple]
         */
        
        // Define the file path to the Countries.plist file in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/Countries.plist"
        
        // Write the NSMutableDictionary to the Countries.plist file in the Document directory
        dict_CountryName_CountryData.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        
        let paths1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath1 = paths1[0] as String
        
        let plistFilePathInDocumentDirectory1 = documentDirectoryPath1 + "/MyTrips.plist"
        
        dict_TripID_TripData.write(toFile: plistFilePathInDocumentDirectory1, atomically: true)
        
        /*
         The flag "atomically" specifies whether the file should be written atomically or not.
         
         If flag atomically is TRUE, the dictionary is first written to an auxiliary file, and
         then the auxiliary file is renamed to path plistFilePathInDocumentDirectory.
         
         If flag atomically is FALSE, the dictionary is written directly to path plistFilePathInDocumentDirectory.
         This is a bad idea since the file can be corrupted if the system crashes during writing.
         
         The TRUE option guarantees that the file will not be corrupted even if the system crashes during writing.
         */
    }
}

