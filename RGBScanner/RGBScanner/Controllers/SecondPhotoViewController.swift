//
//  SecondPhotoViewController.swift
//  RGBScanner
//
//  Created by Cem Genel on 24.10.2019.
//  Copyright © 2019 Cem Kazım. All rights reserved.
//

import UIKit
import AVFoundation

class SecondPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView2: UIImageView!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    var captureMoment: AVCaptureSession!
    var constantImageOutput: AVCapturePhotoOutput!
    var previewStage: AVCaptureVideoPreviewLayer!
    var outputPhotoView2: UIImage!
    var passView: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureMoment = AVCaptureSession()
        captureMoment.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Arka kameraya erisilemiyor.")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            constantImageOutput = AVCapturePhotoOutput()
            if captureMoment.canAddInput(input) && captureMoment.canAddOutput(constantImageOutput) {
                captureMoment.addInput(input)
                captureMoment.addOutput(constantImageOutput)
                setupLivePreview()
            }
        }
        catch let error {
            print("Arka kamera islenemedi: \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureMoment.stopRunning()
    }
    
    func setupLivePreview() {
        previewStage = AVCaptureVideoPreviewLayer(session: captureMoment)
        previewStage.videoGravity = .resizeAspectFill
        previewStage.connection?.videoOrientation = .portrait
        view.layer.addSublayer(previewStage)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureMoment.startRunning()
            DispatchQueue.main.async {
                self.previewStage.frame = self.cameraView2.layer.bounds
            }
        }
    }
    
    @IBAction func didTapOnTakePhotoButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        constantImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: imageData)
        outputPhotoView2 = image
        alertController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = cameraView2.bounds.size
        if let tapPoint = touches.first {
            let x = tapPoint.location(in: cameraView2).y / screenSize.height
            let y = 1.0 - tapPoint.location(in: cameraView2).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
            if let device = AVCaptureDevice.default(for:AVMediaType.video) {
                do {
                    try device.lockForConfiguration()
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                }
                catch {
                }
            }
        }
    }
    
    func alertController() {
        let alertController = UIAlertController(title: "Hangi RGB değeri döndürülsün?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Noktasal Değer", style: .default) { _ in
            self.performSegue(withIdentifier: "PointValuesViewController", sender: true)
        })
        alertController.addAction(UIAlertAction(title: "Ortalama Değer", style: .default) { _ in
            self.performSegue(withIdentifier: "AverageValuesViewController", sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func redPoint(location: CGPoint, size: CGSize) {
        let x : CGFloat = (size.width) * location.x / size.width
        let y : CGFloat = (size.height) * location.y / size.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AverageValuesViewController" {
            let destination = segue.destination as! AverageValuesViewController
            destination.capturedPhoto2 = outputPhotoView2
            destination.capturedPhoto = passView
        }
        if segue.identifier == "PointValuesViewController" {
            let destination = segue.destination as! PointValuesViewController
            destination.capturedPhoto2 = outputPhotoView2
            destination.capturedPhoto = passView
        }
    }
}
