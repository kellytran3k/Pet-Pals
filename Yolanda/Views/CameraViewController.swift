//
//  CameraViewController.swift
//  Yolanda
//
//  Created by Kelly Tran on 11/7/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import AVFoundation
import UIKit
import Firebase


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

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
            metadataOutput.metadataObjectTypes = [.qr]
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

        if let metadataObject =
            metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        
        // references
        let db = Database.database()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
            db.reference().child("users").child(uid).child("recyclables").observeSingleEvent(of: .value) { (DataSnapshot) in
                guard let initialRecyclables = DataSnapshot.value as? Int64 else { return }
                
            db.reference().child("users").child(uid).child("camera-permission").observeSingleEvent(of: .value) { (DataSnapshot) in
                guard var initialCameraPermission = DataSnapshot.value as? Bool else { return }

        //checks if the scanned codes are valid
        if (initialCameraPermission == true) {
        if (code == "Food") {
            //gives points to the users
            db.reference().child("users").child(uid).child("health-points").observeSingleEvent(of: .value) { (DataSnapshot) in
            guard let initialPoints = DataSnapshot.value as? Int64 else { return }
                
            db.reference().child("users").child(uid).child("health-points").setValue(initialPoints + 1)
            print("Points updated successfully")
            
            db.reference().child("users").child(uid).child("recyclables").setValue(initialRecyclables + 1)
                
            }
            
        }
        
        if (code == "Love") {
            
            db.reference().child("users").child(uid).child("love-points").observeSingleEvent(of: .value) { (DataSnapshot) in
                guard let initialPoints = DataSnapshot.value as? Int64 else { return }
                
            db.reference().child("users").child(uid).child("love-points").setValue(initialPoints + 1)
            print("Points updated successfully")
            
            db.reference().child("users").child(uid).child("recyclables").setValue(initialRecyclables + 1)
                
            }
        }
        
        if (code == "Treasure") {
            db.reference().child("users").child(uid).child("luck-points").observeSingleEvent(of: .value) { (DataSnapshot) in
                    guard let initialPoints = DataSnapshot.value as? Int64 else { return }
            db.reference().child("users").child(uid).child("luck-points").setValue(initialPoints + 1)
            print("Points updated successfully")
            db.reference().child("users").child(uid).child("recyclables").setValue(initialRecyclables + 1)

            }
        }
        self.cameraTimer()
        }
        }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func cameraTimer() {
        let db = Database.database()
        guard let uid = Auth.auth().currentUser?.uid else { return }
            db.reference().child("users").child(uid).child("camera-permission").setValue(false)
            print("Camera access denied for 30 minutes successfully")
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ScannerViewController.cameraPermission), userInfo: nil, repeats: false)
    }
    
    @objc func cameraPermission() {
        let db = Database.database()
        guard let uid = Auth.auth().currentUser?.uid else { return }
            db.reference().child("users").child(uid).child("camera-permission").setValue(true)
            print("Camera gained access successfully")
    }
    
}
