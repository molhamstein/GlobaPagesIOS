//
//  AdsCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/7/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class AdsImageCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var lineView2: UIView!
    
    
    var add:Ads?{
        
        didSet{
            
            guard let add = add else {
                return
            }
            self.imageView.image = UIImage(named: add.image)
            self.tagLabel.text = add.tag
            self.titleLabel.text = add.title
            self.addressLabel.text = add.address
            
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // fonts
        self.tagLabel.font =  AppFonts.small
        self.titleLabel.font = AppFonts.normalBold
        self.addressLabel.font = AppFonts.normal
     
        self.roundedBorder(value: 5.0)
        self.addShadow()

      
    }
    
}

