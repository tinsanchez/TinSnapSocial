//
//  ViewController.swift
//  TinSnapSocial
//
//  Created by Valentin Sanchez on 28/05/2020.
//  Copyright © 2020 Valentin Sanchez. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVFoundation


class MainCameraViewController: CameraViewController, AAPLCameraViewDelegate {
    

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureModeControl: UISegmentedControl!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraUnavailableLabel: UILabel!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var livePhotoModeButton: UIButton!
    @IBOutlet weak var depthDataDeliveryButton: UIButton!
    
    @IBOutlet weak var portraitEffectsMatteDeliveryButton: UIButton!
    @IBOutlet weak var photoQualityPrioritizationSegControl: UISegmentedControl!
    @IBOutlet weak var semanticSegmentationMatteDeliveryButton: UIButton!

    
    @IBOutlet weak var capturingLivePhotoLabelMio: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    

    
    override func viewDidLoad() {
        
        self.delegate = self
        
        super._previewView = self.previewView
        
        super._captureModeControl = self.captureModeControl
        self.captureModeControl.addTarget(self, action: #selector(CameraViewController.toggleCaptureMode), for: .valueChanged)
        
        super._cameraButton = self.cameraButton
        self.cameraButton.addTarget(self, action: #selector(CameraViewController.changeCamera), for: .touchUpInside)
        
        super._photoButton = self.photoButton
        self.photoButton.addTarget(self, action: #selector(CameraViewController.capturePhoto), for: .touchUpInside)
        
        super._livePhotoModeButton = self.livePhotoModeButton
        self.livePhotoModeButton.addTarget(self, action: #selector(toggleLivePhotoMode), for: .touchUpInside)
        
        super._depthDataDeliveryButton = self.depthDataDeliveryButton
        self.depthDataDeliveryButton.addTarget(self, action: #selector(toggleDepthDataDeliveryMode), for: .touchUpInside)
        
        super._recordButton = self.recordButton
        self.recordButton.addTarget(self, action: #selector(toggleMovieRecording), for: .touchUpInside)
        
        super._resumeButton = self.resumeButton
        self.resumeButton.addTarget(self, action: #selector(resumeInterruptedSession), for: .touchUpInside)
        
        super._portraitEffectsMatteDeliveryButton = self.portraitEffectsMatteDeliveryButton
        self.portraitEffectsMatteDeliveryButton.addTarget(self, action: #selector(togglePortraitEffectsMatteDeliveryMode), for: .touchUpInside)
        self.portraitEffectsMatteDeliveryButton.alpha = 0
        
        super._photoQualityPrioritizationSegControl = self.photoQualityPrioritizationSegControl
        self.photoQualityPrioritizationSegControl.addTarget(self, action: #selector(togglePhotoQualityPrioritizationMode), for: .valueChanged)
        
        super._semanticSegmentationMatteDeliveryButton = self.semanticSegmentationMatteDeliveryButton
        self.semanticSegmentationMatteDeliveryButton.addTarget(self, action: #selector(toggleSemanticSegmentationMatteDeliveryMode), for: .touchUpInside)
        self.semanticSegmentationMatteDeliveryButton.alpha = 0
        
        
        super._cameraUnavailableLabel = self.cameraUnavailableLabel
        self.cameraUnavailableLabel.alpha = 0
        super._capturingLivePhotoLabel = self.capturingLivePhotoLabelMio
        self.capturingLivePhotoLabelMio.alpha = 0
        super._previewView = self.previewView
        
        
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "ShowLoginVC", sender: nil)
            return
        }
    }
    
    let segueId: String = "ShowFriends"
    
    func videoRecordingComplete(videoURL: URL) {
        performSegue(withIdentifier: self.segueId, sender: ["videoURL" : videoURL])
    }
    
    func videoRecordingFailed(errorMessage: String?) {
        if let error = errorMessage{
            print(error)
        }
    }
    
    func imageTaken(data: Data) {
        DispatchQueue.main.async {
               //do UIWork here
            

            self.performSegue(withIdentifier: self.segueId, sender: ["imageData" : data])
        }
    }
    
    func imageFailed(errorMessage: String?) {
        if let error = errorMessage{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let usersVc = segue.destination as? UsersTableViewController{
            if let videoDict = sender as? Dictionary<String,URL>{
                let videoURL = videoDict["videoURL"]
                usersVc.videoURL = videoURL
            } else if let imageDict = sender as? Dictionary<String, Data>{
                    let imageData = imageDict["imageData"]
                    usersVc.imageData = imageData
            }
            usersVc.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func rightGesture(_ sender: UISwipeGestureRecognizer) {
        presentingViewController?.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "ShowUsers", sender: nil)
    }
    
    @IBAction func leftGesture(_ sender: UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "ShowSnaps", sender: nil)
    }
    
    @IBAction func logoutBottom(_ sender: UIButton) {
        AuthService.shared.logOut()
        self.performSegue(withIdentifier: "ShowLoginVC", sender: nil)
    }
    
    @IBAction func flashActivate(_ sender: UISegmentedControl) {
        /*if self.videoDeviceInput.device.isFlashAvailable {
            MainCameraViewController.capturePhoto(CameraViewController)
            photoSettings.flashMode = .on
        }*/
    }
}

