//
//  MainVC.swift
//  Happy Days
//
//  Created by AKIL KUMAR THOTA on 6/20/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech

class MainVC: UIViewController {
    
    
    @IBOutlet weak var helpLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continuePrsd(_ sender:AnyObject) {
        
        requestPhotoPermission()
        
    }
    
    
    func requestPhotoPermission() {
        
        PHPhotoLibrary.requestAuthorization { [unowned self] authStatus in
            
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.requestRecordPermission()
                }else{
                    self.helpLabel.text = "Photo permission was denied"
                }
            }
        }
        
    }
    
    
    func requestRecordPermission() {
        
        AVAudioSession.sharedInstance().requestRecordPermission { [unowned self]allowed in
            
            DispatchQueue.main.async {
                if allowed {
                    self.requestTranscribePermission()
                }else{
                    self.helpLabel.text = "Record permission was Denied"
                }
            }
            
        }
        
    }
    
    func requestTranscribePermission() {
        
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.allPermissionGranted()
                }else{
                    self.helpLabel.text = "Transcriber Permission was denied"
                }
            }
        }
        
    }
    
    
    func allPermissionGranted() {
        dismiss(animated: true, completion: nil)
    }
    
}



