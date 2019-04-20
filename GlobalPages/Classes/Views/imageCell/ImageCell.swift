//
//  ImageCell.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

protocol ImageCellDelegete {
    func deleteImage(tag:Int)
    func deleteVideo(tag:Int)
}


class ImageCell: UICollectionViewCell {

    @IBOutlet weak var iamgeView: UIImageView!
    
    @IBOutlet weak var playbackImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate:ImageCellDelegete?
    
    var isVideo: Bool = false
    
    var image:UIImage?{
        didSet{
            guard let image = image else {
                return
            }
            iamgeView.image = image
        }
    }
    
    
    var media:Media?{
        
        didSet{
            guard let media = media else {
                return
            }
            
            let url: String?
            if media.type == AppMediaType.video {
                url = media.thumbUrl
                playbackImageView.isHidden = false
            }else {
                url = media.fileUrl
                playbackImageView.isHidden = true
            }
            
            if var url = url {
                if !url.contains(find: "http://") {
                    url = "http://" + url
                }
                iamgeView.setImageForURL(url, placeholder: #imageLiteral(resourceName: "AI_Image"))
            }
            
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func editMode(state:Bool){
        self.deleteButton.isHidden = !state
        self.cornerRadius = 5
    }

    @IBAction func remove(_ sender: UIButton) {
        if isVideo {
            delegate?.deleteVideo(tag:self.tag)
        }else{
            delegate?.deleteImage(tag:self.tag)
        }
        
    }
}
