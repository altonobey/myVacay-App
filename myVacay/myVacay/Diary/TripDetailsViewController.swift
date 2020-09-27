//
//  TripDetailsViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Nolan Turley. All rights reserved.
//

import UIKit
import MessageUI

class TripDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var imageButton: UIButton!
    @IBOutlet var tripTitle: UILabel!
    @IBOutlet var tripLocation: UILabel!
    @IBOutlet var tripDescription: UITextView!
    
    var tripDataPassed = [String]()
    var tripImageValue = UIImage(named: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = tripDataPassed[2]
        
        tripTitle.text = tripDataPassed[0]
        tripLocation.text = tripDataPassed[1]
        tripDescription.text = tripDataPassed[3]
        
        tripImageValue = UIImage(contentsOfFile: tripDataPassed[4])
        if (UIImage(contentsOfFile: tripDataPassed[4]) == nil ) {
            tripImageValue = UIImage(named: "NoImageAvailable.png")
        }
        
        imageButton.setImage(tripImageValue, for: .normal)
        imageButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        
    }
    

    @IBAction func tripButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "viewTripImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (tripImageValue == nil) {
            tripImageValue = UIImage(named: "NoImageAvailable.png")
        }
        else {
            let TripImageViewController: TripImageViewController = segue.destination as! TripImageViewController
            TripImageViewController.imageNamePassed = tripImageValue
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

    
    @IBAction func emailButtonTapped(_ sender: UIBarButtonItem) {
        let picture = UIImage(contentsOfFile: tripDataPassed[4])
        let pictureView = UIImageView(image: picture)
        //if (picture != nil) {
            sendMail(imageView: pictureView)
        //} else {
            //showAlertMessage(messageHeader: "Cannot Email Example", messageBody: "Sorry but we can not email the example trip")
        //}
    }
    
    func sendMail(imageView: UIImageView) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            let subject = "Here's My Trip From " + tripDataPassed[2] + "!"
            mail.setSubject(subject)
            let body = "<p>" + tripDataPassed[0] + "</p><p>" + tripDataPassed[1] + "</p><p>" + tripDataPassed[3] + "</p>"
            mail.setMessageBody(body, isHTML: true)
            if (imageView.image != nil) {
                let imageData: NSData = imageView.image!.jpegData(compressionQuality: 1)! as NSData
                mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName.png")
            }
            self.present(mail, animated: true, completion: nil)
        } else {
            showAlertMessage(messageHeader: "Cannot Send Mail", messageBody: "This function requiers a mail account to be set up")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
