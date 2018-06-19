//
//  AdsCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/7/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class AdsImageCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var add:Ads?{
        
        didSet{
            
            guard let add = add else {
                return
            }
            if add.type == .image{
                self.topView.isHidden = false
                self.imageView.image = UIImage(named: add.image)
                self.titleLabel.heightAnchor.constraint(equalToConstant: 92).isActive = true
                self.layoutSubviews()
            }else{
                let height = add.title.getLabelHeight(width: self.contentView.frame.width - 16, font: UIFont.systemFont(ofSize: 17))
                self.titleLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
                self.layoutSubviews()
                self.topView.isHidden = true
                self.titleLabel.text = add.title
            }
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
        
        
        
        self.roundedBorder(value: 5.0)
        self.addShadow()
    }
    
}

