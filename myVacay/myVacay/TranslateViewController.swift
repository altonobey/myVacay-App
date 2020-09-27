//
//  TranslateViewController.swift
//  myVacay
//
//  Created by Nolan Turley on 12/3/18.
//  Copyright © 2018 Nolan Turley. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateViewController: UIViewController {

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var text:UITextField!
    @IBOutlet var fromLanguage:UILabel!
    @IBOutlet var toLanguage:UILabel!
    @IBOutlet var translation:UILabel!
    
    @IBOutlet var speakTranslation: UIButton!
    
    var firstLanguageSent = ""
    var secondLanguageSent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromLanguage.text = firstLanguageSent
        toLanguage.text = secondLanguageSent
        translation.text = ""
    }
    
    @IBAction func translate() {
        let firstLangArray = applicationDelegate.dict_Lang_Id.value(forKey: firstLanguageSent) as! [String]
        let secondLangArray = applicationDelegate.dict_Lang_Id.value(forKey: secondLanguageSent) as! [String]
        
        let firstCode = firstLangArray[0]
        let secondCode = secondLangArray[0]
        
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyANX0c5yeOO_g9r71WReE5Tup2bkBKK3-M" // Add your API Key here
        
        var params = ROGoogleTranslateParams()
        params.source = firstCode
        params.target = secondCode
        params.text = text.text ?? "The textfield is empty"
        
        translator.translate(params: params) { (result) in
            DispatchQueue.main.async {
                self.translation.text = "\(result)"
            }
        }
    }
    
    @IBAction func speakFirstLanguageTapped(_ sender: Any) {
        let secondLangArray = applicationDelegate.dict_Lang_Id.value(forKey: secondLanguageSent) as! [String]
        
        let utterance = AVSpeechUtterance(string: translation.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "\(secondLangArray[0])-\(secondLangArray[1])")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //if the phone was shaken
        if motion == .motionShake {
            text.text = ""
            translation.text = ""
            let temp = fromLanguage.text
            fromLanguage.text = toLanguage.text
            toLanguage.text = temp
            
            let hold = firstLanguageSent
            firstLanguageSent = secondLanguageSent
            secondLanguageSent = hold
        }
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
}
