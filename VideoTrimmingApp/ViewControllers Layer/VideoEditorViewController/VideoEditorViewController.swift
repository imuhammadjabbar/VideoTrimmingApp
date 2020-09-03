//
//  VideoEditorViewController.swift
//  VideoTrimmingApp
//
//  Created by Jabbar on 02/09/2020.
//  Copyright © 2020 Jabbar. All rights reserved.
//

import UIKit
import AVKit

class VideoEditorViewController: UIViewController {

    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var btnBrowseVideo: UIButton!
    @IBOutlet weak var btnRecordVideo: UIButton!
    
    //
    // MARK: - Properties
    //
    let helper = VideoEditorVCHelper();
    let picker = UIImagePickerController();
    
    //
    // MARK: - View Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        self.setup();
    }
    
    //
    // MARK: - Setup UI
    //
    func setup() {
        
        // Self Assignment
        self.helper.videoEditorVC = self;
        
        // Setting Button Corner Radius
        self.btnBrowseVideo.layer.cornerRadius = 6.0;
        self.btnRecordVideo.layer.cornerRadius = 6.0;
        
        // Setting Picker Properties
        self.picker.delegate = self;
        self.picker.mediaTypes = ["public.movie"];
        /// Trim Video to 30 Seconds -- [ 2 Minutes Solution ] --  START
        // self.picker.allowsEditing = true;
        // self.picker.videoMaximumDuration = 30.0;
        /// Trim Video to 30 Seconds -- [ 2 Minutes Solution ] --  END
        
    }
    
    //
    // MARK: - IBActions
    //
    @IBAction func btnBrowseVideoAction(_ sender: UIButton) {
        print("btnBrowseVideoAction is Called...");
        
        // Setting Picker Source
        self.picker.sourceType = .photoLibrary;
        
        // Present Picker
        self.present(self.picker, animated: true, completion: {});
        
    }
    
    @IBAction func btnRecordVideoAction(_ sender: UIButton) {
        print("btnRecordVideoAction is Called...");
        
        // Setting Picker Source
        self.picker.sourceType = .camera;
        
        // Present Picker
        self.present(self.picker, animated: true, completion: {});
    }
    
}


//
// MARK: - Picker Delegates + Related Methods
//
extension VideoEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL {
            print("Original Video URL: \(videoURL)");
            self.dismiss(animated: true, completion: {
                
                self.helper.trimVideo(sourceURL: videoURL, startTime: 0.0, endTime: 30.0, completion: { trimmedVideoURL in
                    print("Trimmed Video URL: \(trimmedVideoURL)");
                    
                    // Play Video from within the Main Thread
                    DispatchQueue.main.async {
                        self.helper.play(video: trimmedVideoURL);
                    }
                    
                })
            })
        }
    }
    
    // Delegate Method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
