//
//  LanguageSelectViewController.swift
//  myVacay
//
//  Created by Nolan Turley on 12/3/18.
//  Copyright © 2018 Nolan Turley. All rights reserved.
//

import UIKit

class LanguageSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var language1: UIPickerView!
    @IBOutlet var language2: UIPickerView!
    
    
    var languagesData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languagesData = applicationDelegate.dict_Lang_Id.allKeys as! [String]
        languagesData.sort { $0 < $1 }
        
        language1.selectRow(Int(languagesData.count / 2), inComponent: 0, animated: false)
        language2.selectRow(Int(languagesData.count / 2), inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagesData[row]
    }
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "translate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "translate" {
            let TranslateViewController: TranslateViewController = segue.destination as! TranslateViewController
            let firstRow = language1.selectedRow(inComponent: 0)
            let secondRow = language2.selectedRow(inComponent: 0)
            TranslateViewController.firstLanguageSent = languagesData[firstRow]
            TranslateViewController.secondLanguageSent = languagesData[secondRow]
        }
    }

}
