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
}


class ImageCell: UICollectionViewCell {

    @IBOutlet weak var iamgeView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate:ImageCellDelegete?
    
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
            let url = media.fileUrl
            iamgeView.setImageForURL(url ?? "", placeholder: #imageLiteral(resourceName: "AI_Image"))
            
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
        delegate?.deleteImage(tag:self.tag)
    }
}
