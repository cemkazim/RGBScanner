//
//  ImageContents.swift
//  RGBScanner
//
//  Created by Cem Kazım on 19.03.2021.
//  Copyright © 2021 Cem Kazım. All rights reserved.
//

import UIKit

enum ImageContents {
    typealias RawValue = UIImage
    
    case rgbIcon
    case continueButtonImage
    case invertedRgbIcon
    
    var value: UIImage {
        switch self {
        case .rgbIcon:
            return UIImage(imageLiteralResourceName: "rgb_scanner.png")
        case .continueButtonImage:
            return UIImage(imageLiteralResourceName: "start-button.png")
        case .invertedRgbIcon:
            return UIImage(imageLiteralResourceName: "invert_rgb.png")
        }
    }
}
