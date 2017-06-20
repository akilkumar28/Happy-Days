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

class MemoryVC: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout{
    
    
    var memories = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        loadMemories()
        
    }
    
    func addTapped() {
        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.modalPresentationStyle  = .formSheet
        navigationController?.present(imageVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            saveNewMemory(image: imagePicked)
            loadMemories()
        }
    }
    
    
    func saveNewMemory(image:UIImage) {
        
        let memoryName = "memory-\(Date().timeIntervalSince1970)"
        
        let imageName = memoryName + ".jpg"
        let thumbName = memoryName + ".thumb"
        
        do {
            
            let imagePath = documentDirectories().appendingPathComponent(imageName)
            
            if let jpegImage = UIImageJPEGRepresentation(image, 80) {
                try jpegImage.write(to: imagePath, options: .atomicWrite)
            }
            if let thumbNail = reSize(image: image, to: 200) {
                let thumbPath = documentDirectories().appendingPathComponent(thumbName)
                
                if let jpegThumb = UIImageJPEGRepresentation(thumbNail, 80) {
                    try jpegThumb.write(to: thumbPath, options: .atomicWrite)
                }
            }
            
        } catch {
            print("Save Failed")
        }
        
    }
    
    
    func reSize(image:UIImage,to width:CGFloat) -> UIImage? {
        let scale = width / image.size.width
        
        let height = image.size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
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
    
    func imageUrl(for memory:URL) -> URL{
        return memory.appendingPathExtension("jpg")
        
    }
    
    func thubNailUrl(for memory:URL) -> URL{
        return memory.appendingPathExtension("thumb")
        
    }
    func audioUrl(for memory:URL) -> URL{
        return memory.appendingPathExtension("m4a")
        
    }
    func transcriptionUrl(for memory:URL) -> URL{
        return memory.appendingPathExtension("txt")
        
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else {
            return memories.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memory", for: indexPath) as! MemoryCell
        
        let memory = memories[indexPath.row]
        
        let imageName = thubNailUrl(for: memory).path
        
        let image = UIImage(contentsOfFile: imageName)
        
        cell.memoryImage.image = image
        
        return cell
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
        }else{
            return CGSize(width: 0, height: 50)
    }
    
    }
    
}
