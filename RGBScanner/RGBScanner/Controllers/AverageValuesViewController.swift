//
//  AverageValuesViewController.swift
//  RGBScanner
//
//  Created by Cem Genel on 5.10.2019.
//  Copyright © 2019 Cem Kazım. All rights reserved.
//

import UIKit

class AverageValuesViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoView2: UIImageView!
    @IBOutlet weak var blueValue2: UILabel!
    @IBOutlet weak var greenValue2: UILabel!
    @IBOutlet weak var redValue2: UILabel!
    @IBOutlet weak var blueLabel2: UILabel!
    @IBOutlet weak var greenLabel2: UILabel!
    @IBOutlet weak var redLabel2: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var differenceRedLabel: UILabel!
    @IBOutlet weak var differenceGreenLabel: UILabel!
    @IBOutlet weak var differenceBlueLabel: UILabel!
    @IBOutlet weak var differenceRedValue: UILabel!
    @IBOutlet weak var differenceGreenValue: UILabel!
    @IBOutlet weak var differenceBlueValue: UILabel!
    
    var isSaved: Bool?
    var isHidden: Bool?
    var capturedPhoto: UIImage!
    var capturedPhoto2: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.black
        setupOutputImagesColorAverage()
    }
    
    func setupOutputImagesColorAverage() {
        photoView.image = capturedPhoto
        let color = capturedPhoto?.capturedPhotoColorAverage()
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        redValue.text = "\(Int(floor(red)))"
        greenValue.text = "\(Int(floor(green)))"
        blueValue.text = "\(Int(floor(blue)))"
        photoView2.image = capturedPhoto2
        let color2 = capturedPhoto2?.capturedPhotoColorAverage()
        var red2 = red
        var green2 = green
        var blue2 = blue
        var alpha2 = alpha
        color2?.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        redValue2.text = "\(Int(floor(red2)))"
        greenValue2.text = "\(Int(floor(green2)))"
        blueValue2.text = "\(Int(floor(blue2)))"
        if (red2 - red) < 0 {
            differenceRedValue.text = "\(Int(floor(-(red2-red))))"
        } else {
            differenceRedValue.text = "\(Int(floor(red2-red)))"
        }
        if (green2 - green) < 0 {
            differenceGreenValue.text = "\(Int(floor(-(green2-green))))"
        } else {
            differenceGreenValue.text = "\(Int(floor(green2-green)))"
        }
        if (blue2 - blue) < 0 {
            differenceBlueValue.text = "\(Int(floor(-(blue2-blue))))"
        } else {
            differenceBlueValue.text = "\(Int(floor(blue2-blue)))"
        }
    }
    
    @IBAction func savedRGBValuesButton(_ sender: UIButton) {
        if (redValue.text != nil && greenValue.text != nil && blueValue.text != nil && redValue2.text != nil && greenValue2.text != nil && blueValue2.text != nil) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(redValue.text ,forKey: "isSavedRedValue")
            userDefaults.set(greenValue.text ,forKey: "isSavedGreenValue")
            userDefaults.set(blueValue.text ,forKey: "isSavedBlueValue")
            userDefaults.set(redValue2.text ,forKey: "isSavedRedValue2")
            userDefaults.set(greenValue2.text ,forKey: "isSavedGreenValue2")
            userDefaults.set(blueValue2.text ,forKey: "isSavedBlueValue2")
            userDefaults.set(differenceRedValue.text ,forKey: "isSavedDifferenceRedValue")
            userDefaults.set(differenceGreenValue.text ,forKey: "isSavedDifferenceGreenValue")
            userDefaults.set(differenceBlueValue.text ,forKey: "isSavedDifferenceBlueValue")
            isSaved = true
            userDefaults.set(isSaved, forKey: "isSaved")
            let alertController = UIAlertController(title: "Kaydedildi.", message: "RGB değerlerine Kaydedilenler sekmesinden ulaşabilirsiniz.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: {Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            isHidden = false
            userDefaults.set(isHidden, forKey: "isHidden")
        }
    }
    
    @IBAction func lastSavedValuesButton(_ sender: UIBarButtonItem) {
        if (redValue.text != nil && blueValue.text != nil && greenValue.text != nil && redValue2.text != nil && blueValue2.text != nil && greenValue2.text != nil) {
            performSegue(withIdentifier: "SavedRGBValues", sender: nil)
        }
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startPageViewController = storyboard.instantiateViewController(withIdentifier: "BeginnerPageViewController") as! StartPageViewController
        self.navigationController?.pushViewController(startPageViewController, animated: true)
    }
}

extension UIImage {
    func capturedPhotoColorAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        let customCIContext = CIContext(options: nil)
        let cgImagesValue = customCIContext.createCGImage(CoreImage.CIImage(cgImage: self.cgImage!), from: CoreImage.CIImage(cgImage: self.cgImage!).extent)
        let inputView = CIImage(cgImage: cgImagesValue!)
        let customCGRect = inputView.extent
        let inputExtent = CIVector(x: customCGRect.origin.x, y: customCGRect.origin.y, z: customCGRect.size.width, w: customCGRect.size.height)
        let customCIFilter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputView, kCIInputExtentKey: inputExtent])!
        let outputView = customCIFilter.outputImage!
        let outputRating = outputView.extent
        assert(outputRating.size.width == 1 && outputRating.size.height == 1)
        customCIContext.render(outputView, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        let outcome = UIColor(red: CGFloat(bitmap[0]), green: CGFloat(bitmap[1]), blue: CGFloat(bitmap[2]), alpha: CGFloat(bitmap[3]))
        return outcome
    }
}
