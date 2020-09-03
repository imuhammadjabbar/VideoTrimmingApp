//
//  VideoEditorVCHelper.swift
//  VideoTrimmingApp
//
//  Created by Jabbar on 03/09/2020.
//  Copyright © 2020 Jabbar. All rights reserved.
//

import Foundation
import AVKit

class VideoEditorVCHelper: NSObject {
    
    //
    // MARK: - Properties
    //
    let playerController = AVPlayerViewController()
    weak var videoEditorVC : VideoEditorViewController?
    
    // Play
    func play(video: URL) {
        let player = AVPlayer(url: video)
        self.playerController.player = player
        self.videoEditorVC!.present(self.playerController, animated: true) {
            player.play()
        }
    }
    
    // Trim Video
    func trimVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: ((_ outputUrl: URL) -> Void)? = nil) {
        
        // File Manger & Document Directory
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Creating Video Asset
        let asset = AVAsset(url: sourceURL)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("Original Video Length: \(length) Seconds")
        
        // Creating Output Video Path
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(sourceURL.lastPathComponent).mp4")
            
        } catch let error {
            print(error)
        }
        
        /// Remove Existing/Previous File [Avoid Extensive Memory Usage]
        try? fileManager.removeItem(at: outputURL)
        
        // Asset to be Export
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        // Trimming Range(Start - End)
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000), end: CMTime(seconds: endTime, preferredTimescale: 1000))
        exportSession.timeRange = timeRange
        
        // Export / Completion Block
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Trimmed Video Link: \(outputURL)")
                completion?(outputURL)
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
            default: break
            }
        }
    }
    
}
