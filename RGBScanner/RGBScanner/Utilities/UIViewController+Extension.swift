//
//  UIViewController+Extension.swift
//  RGBScanner
//
//  Created by Cem Kazım on 19.03.2021.
//  Copyright © 2021 Cem Kazım. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func navigateTo(storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
