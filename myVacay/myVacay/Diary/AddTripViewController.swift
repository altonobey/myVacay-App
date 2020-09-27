//
//  AddTripViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Nolan Turley. All rights reserved.
//

import UIKit
import Speech

class AddTripViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet var tripImage: UIImageView!
    @IBOutlet var tripName: UITextField!
    @IBOutlet var tripLocation: UITextField!
    @IBOutlet var tripDescription: UITextView!
    var imageLocation = ""
    @IBOutlet var tripDate: UIDatePicker!
    var imagePickerController : UIImagePickerController!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBOutlet var voiceButton: UIButton!
    var recordingOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripDescription.text = ""
        
    }
    
    func recordAndRecognizeSpeech() {
        if (audioEngine.isRunning) {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {buffer, _ in self.request.append(buffer)}
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.tripDescription.text = result.bestTranscription.formattedString
            } else if let error = error {
                print (error)
            }
        })
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func photoSelectedToSave(_ sender: Any) {
        let currentDateTime = Date()
        saveImage(imageName: String(currentDateTime.timeIntervalSince1970))
        showAlertMessage(messageHeader: "Image Has Been Saved", messageBody: "The image has been successfully saved")
    }
    
    @IBAction func voiceToTextPressed(_ sender: UIButton) {
        if (!recordingOn) {
            recordingOn = true
            voiceButton.setTitle("Stop Recording", for: .normal)
            self.recordAndRecognizeSpeech()
        } else {
            recordingOn = false
            voiceButton.setTitle("Reset and Record", for: .normal)
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            request.endAudio()
        }
    }
    
    func saveImage(imageName: String){
        if (tripImage.image == nil) {
            tripImage.image = UIImage(named: "NoImageAvailable.png")
        }
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        imageLocation = imagePath
        //get the image we took with camera
        let image = tripImage.image!
        //get the PNG data for this image
        let data = image.jpegData(compressionQuality: 1)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        tripImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
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
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        view.endEditing(true)
    }
    
    @IBAction func keyboardDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
