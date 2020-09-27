//
//  LandmarkViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit
import Firebase

class LandmarkViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var resultView: UITextView!
    let imagePicker = UIImagePickerController()
    let options = VisionCloudDetectorOptions()
    lazy var vision = Vision.vision()
    var activity = ActivityIndicator(text: "Loading Result")
    var landmarkToPass = ""
    var locationToPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        options.modelType = .latest
        options.maxResults = 5
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        self.view.addSubview(self.activity)
        
        locationToPass.removeAll()
        landmarkToPass.removeAll()
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            let landmarkDetector = vision.cloudLandmarkDetector(options: options)
            let visionImage = VisionImage(image: pickedImage)
            
            self.resultView.text = ""
            landmarkDetector.detect(in: visionImage) { (landmarks, error) in
                guard error == nil, let landmarks = landmarks, !landmarks.isEmpty else {
                    self.resultView.text = "No landmarks detected"
                    self.activity.hide()
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                
                for landmark in landmarks {
                    let landmarkDescription = landmark.landmark!
                    self.landmarkToPass = "\(landmarkDescription)"
                    self.resultView.text = self.resultView.text + "Landmark Description: \(landmarkDescription)"
                    self.activity.hide()
                    
                    for location in landmark.locations! {
                        let latitude = Float(truncating: location.latitude!)
                        let longitude = Float(truncating: location.longitude!)
                        self.locationToPass = "\(latitude), \(longitude)"
                        break
                    }
                    break
                }
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showOnMap(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowOnMap", sender: self)
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        performSegue(withIdentifier: "MoreInfo", sender: self)
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
        
        if segue.identifier == "ShowOnMap" {
            
            // Obtain the object reference of the destination view controller
            let googleMapWebViewController: GoogleMapWebViewController = segue.destination as! GoogleMapWebViewController
            // Pass the data object to the downstream view controller object
            if (locationToPass == "") {
                showAlertMessage(messageHeader: "No Landmark to Show on Map", messageBody: "Please take a photo of a landmark and try again!")
            }
            googleMapWebViewController.location = locationToPass
            googleMapWebViewController.landmark = landmarkToPass
            
        } else if segue.identifier == "MoreInfo" {
            let googleSearchWebViewController: GoogleSearchWebViewController = segue.destination as! GoogleSearchWebViewController
            // Pass the data object to the downstream view controller object
            if ( landmarkToPass == "") {
                showAlertMessage(messageHeader: "No Landmark to Show on Map", messageBody: "Please take a photo of a landmark and try again!")
            }
            googleSearchWebViewController.landmark = landmarkToPass
        }
    }
}
