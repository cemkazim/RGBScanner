//
//  SavedRGBValues.swift
//  RGBScanner
//
//  Created by Cem Kazım on 6.12.2019.
//  Copyright © 2019 Cem Kazım. All rights reserved.
//

import UIKit

class SavedRGBValues: UIViewController {
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel2: UILabel!
    @IBOutlet weak var greenLabel2: UILabel!
    @IBOutlet weak var blueLabel2: UILabel!
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    @IBOutlet weak var redValue2: UILabel!
    @IBOutlet weak var greenValue2: UILabel!
    @IBOutlet weak var blueValue2: UILabel!
    @IBOutlet weak var differenceRedLabel: UILabel!
    @IBOutlet weak var differenceGreenLabel: UILabel!
    @IBOutlet weak var differenceBlueLabel: UILabel!
    @IBOutlet weak var differenceRedValue: UILabel!
    @IBOutlet weak var differenceGreenValue: UILabel!
    @IBOutlet weak var differenceBlueValue: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var isSaved : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        isSaved = userDefaults.bool(forKey: "isSaved")
        deleteButton.isHidden = userDefaults.bool(forKey: "isHidden")
        configureRGBValues()
    }
    
    func configureRGBValues() {
        if isSaved == true {
            let userDefaults = UserDefaults.standard
            redValue.text = userDefaults.string(forKey: "isSavedRedValue")
            greenValue.text = userDefaults.string(forKey: "isSavedGreenValue")
            blueValue.text = userDefaults.string(forKey: "isSavedBlueValue")
            redValue2.text = userDefaults.string(forKey: "isSavedRedValue2")
            greenValue2.text = userDefaults.string(forKey: "isSavedGreenValue2")
            blueValue2.text = userDefaults.string(forKey: "isSavedBlueValue2")
            differenceRedValue.text = userDefaults.string(forKey: "isSavedDifferenceRedValue")
            differenceGreenValue.text = userDefaults.string(forKey: "isSavedDifferenceGreenValue")
            differenceBlueValue.text = userDefaults.string(forKey: "isSavedDifferenceBlueValue")
        } else {
            redValue.text = ""
            greenValue.text = ""
            blueValue.text = ""
            redValue2.text = ""
            greenValue2.text = ""
            blueValue2.text = ""
            differenceRedValue.text = ""
            differenceGreenValue.text = ""
            differenceBlueValue.text = ""
        }
    }
    
    @IBAction func deleteAllRGBValuesButton(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        if (redValue.text != nil && greenValue.text != nil && blueValue.text != nil  && redValue2.text != nil && greenValue2.text != nil && blueValue2.text != nil && differenceRedValue.text != nil && differenceGreenValue.text != nil && differenceBlueValue.text != nil) {
            redValue.text = ""
            greenValue.text = ""
            blueValue.text = ""
            redValue2.text = ""
            greenValue2.text = ""
            blueValue2.text = ""
            differenceRedValue.text = ""
            differenceGreenValue.text = ""
            differenceBlueValue.text = ""
            isSaved = false
            userDefaults.set(isSaved, forKey: "isSaved")
            let alertController = UIAlertController(title: "Silindi.", message: "RGB değerleri başarıyla silindi.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: {Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            deleteButton.isHidden = true
            userDefaults.set(deleteButton.isHidden, forKey: "isHidden")
        }
    }
}
