//
//  ScanRunningViewController.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import AVFoundation

class ScanRunningViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        
        var codeToDisplay = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.black
            captureSession = AVCaptureSession()
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
            } else {
                failed()
                return
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        }
        
        func failed() {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }
            
            let actionSheet = UIAlertController(title: "Caro, T'as vu comme je suis fort !!", message: "Le code ISBN est \(codeToDisplay).", preferredStyle: .alert)
            
            actionSheet.addAction(UIAlertAction(title: "Je suis trop fort", style: .default, handler: { (action: UIAlertAction) in
                
                
                self.dismiss(animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
                self.dismiss(animated: true)
            }))
            
            self.present(actionSheet, animated: true, completion : nil)
            
            
            
            
            
            
            //self.performSegue(withIdentifier: "backToOne", sender: self)
            
            
        }
        
        func found(code: String) {
            codeToDisplay = code
            scannedIsbn = code
            
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
        
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
}
