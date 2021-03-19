//
//  StartPageViewController.swift
//  RGBScanner
//
//  Created by Cem Kazım on 6.12.2019.
//  Copyright © 2019 Cem Kazım. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {
    
    private lazy var headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageContents.rgbIcon.value, for: .normal)
        button.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageContents.continueButtonImage.value, for: .normal)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc func headerButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            headerButton.setImage(ImageContents.rgbIcon.value, for: .normal)
        } else {
            headerButton.setImage(ImageContents.invertedRgbIcon.value, for: .normal)
        }
    }
    
    @objc func continueButtonTapped() {
        navigateTo(storyboardName: StoryboardId.main, viewControllerName: ViewControllerId.firstPhotoViewControllerId)
    }
}

extension StartPageViewController {
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = UIColor.black
        view.backgroundColor = .black
        view.addSubview(headerButton)
        view.addSubview(continueButton)
        addRightBarButtonItem()
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            headerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerButton.widthAnchor.constraint(equalToConstant: 100),
            headerButton.heightAnchor.constraint(equalToConstant: 100),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 100),
            continueButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func addRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: Constants.lastSavedText, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func rightBarButtonItemTapped() {
        navigateTo(storyboardName: StoryboardId.main, viewControllerName: ViewControllerId.lastSavedId)
    }
}
