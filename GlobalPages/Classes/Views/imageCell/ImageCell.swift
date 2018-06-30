//
//  ImageCell.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var iamgeView: UIImageView!
    
    
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

}
