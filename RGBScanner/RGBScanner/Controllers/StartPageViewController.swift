//
//  StartPageViewController.swift
//  RGBScanner
//
//  Created by Cem Kazım on 6.12.2019.
//  Copyright © 2019 Cem Kazım. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIButton!
    @IBOutlet weak var starterButtonObject: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customIconView = UIImage(named: "rgb_scanner.png")
        iconView.setImage(customIconView, for: .normal)
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func starterButton(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstPhotoViewController", sender: nil)
    }
    
    @IBAction func lastSavedButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "LastSaved", sender: nil)
    }
    
    @IBAction func iconViewChanger(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if (sender.isSelected == true) {
            let secondIconView = UIImage(named: "invert_rgb.png")
            iconView.setImage(secondIconView, for: .normal)
        } else {
            let firstIconView = UIImage(named: "rgb_scanner.png")
            iconView.setImage(firstIconView, for: .normal)
        }
    }
}
