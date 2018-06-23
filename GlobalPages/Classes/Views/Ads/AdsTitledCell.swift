//
//  AdsCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/7/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class AdsTitledCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var lineView2: UIView!
    
    var add:Ads?{
        
        didSet{
            
            guard let add = add else {
                return
            }
            
            self.titleLabel.text = add.title
            self.tagLabel.text = add.tag
            self.descriptionLabel.text = add.info
            self.addressLabel.text = add.address
            
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // fonts
        self.tagLabel.font = UIFont.systemFont(ofSize: 12)
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        self.addressLabel.font = UIFont.systemFont(ofSize: 17)
        self.titleLabel.font = UIFont.systemFont(ofSize: 17)
        
        
        
        // colors
       // self.tagView.applyGradient(colours: [AppColors.yellowLight,AppColors.yellowDark], direction: .horizontal)
      //  self.lineView.backgroundColor = AppColors.yellowLight
        //self.lineView2.backgroundColor = AppColors.yellowLight
        
        
    
        self.roundedBorder(value: 5.0)
        self.addShadow()
    }
    
}


