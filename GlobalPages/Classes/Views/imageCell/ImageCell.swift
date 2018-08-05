//
//  ImageCell.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

protocol ImageCellDelegete {
    func deleteImage()
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
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func editMode(){
        self.deleteButton.isHidden = false
        self.cornerRadius = 5
    }

    @IBAction func remove(_ sender: UIButton) {
        delegate?.deleteImage()
    }
}
