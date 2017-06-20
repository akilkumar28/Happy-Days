//
//  MemoryVC.swift
//  Happy Days
//
//  Created by AKIL KUMAR THOTA on 6/20/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import Photos

class MemoryVC: UICollectionViewController {
    
    
    var memories = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func checkPermission() {
        
        let photoAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized
        let audioAuthorized = AVAudioSession.sharedInstance().recordPermission() == .granted
        let transcriberPermission = SFSpeechRecognizer.authorizationStatus() == .authorized
        
        let permission = photoAuthorized && audioAuthorized && transcriberPermission
        
        
        if permission == false {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "firstRun") {
                navigationController?.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermission()
    }
    
    
    func documentDirectories() -> URL {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
        
    }
    
    func loadMemories() {
        
        memories.removeAll()
        
        
        guard let files = try? FileManager.default.contentsOfDirectory(at: documentDirectories(),includingPropertiesForKeys: nil,options:[]) else{
            return
        }
        
        for file in files {
            
            let fileName = file.lastPathComponent
            
            if fileName.hasSuffix(".thumb"){
                
                let noExtension = fileName.replacingOccurrences(of: ".thumb", with: "")
                
                let memoryPath = documentDirectories().appendingPathComponent(noExtension)
                
                memories.append(memoryPath)
            }
            
        }
        
        collectionView?.reloadSections(IndexSet(integer: 1))
        
    }


}
