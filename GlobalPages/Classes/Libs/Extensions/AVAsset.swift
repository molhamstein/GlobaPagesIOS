//
//  AVAsset.swift
//  GlobalPages
//
//  Created by Abdulrahman Alhayek on 4/20/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation
import UIKit

extension AVAsset{
    var videoThumbnail: UIImage? {
        
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = self.duration
        time.value = min(time.value, 1)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            
            
            return thumbNail
            
        } catch {
  
            return nil
            
            
        }
        
    }
}
