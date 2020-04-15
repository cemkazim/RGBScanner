//
//  FirstPhotoViewController.swift
//  RGBScanner
//
//  Created by Cem Genel on 4.10.2019.
//  Copyright © 2019 Cem Kazım. All rights reserved.
//

import UIKit
import AVFoundation

class FirstPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    var captureMoment: AVCaptureSession!
    var constantImageOutput: AVCapturePhotoOutput!
    var previewStage: AVCaptureVideoPreviewLayer!
    var outputPhotoView: UIImage!
    
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
            print("Arka kamera calistirilamiyor: \(error.localizedDescription)")
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
                self.previewStage.frame = self.cameraView.layer.bounds
            }
        }
    }
    
    @IBAction func didTapOnTakePhotoButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        constantImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = cameraView.bounds.size
        if let tapPoint = touches.first {
            let x = tapPoint.location(in: cameraView).y / screenSize.height
            let y = 1.0 - tapPoint.location(in: cameraView).x / screenSize.width
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: imageData)
        outputPhotoView = image
        performSegue(withIdentifier: "SecondPhotoViewController", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SecondPhotoViewController" {
            let destination = segue.destination as! SecondPhotoViewController
            destination.passView = outputPhotoView
        }
    }
}
