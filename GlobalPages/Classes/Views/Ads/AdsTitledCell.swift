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
    @IBOutlet weak var tagViewWidthConstraint: XNSLayoutConstraint!
    @IBOutlet weak var tagLabelWidthConstraint: XNSLayoutConstraint!
    
    var tagLabelWidht:CGFloat = 0 {
        didSet{
            tagLabelWidthConstraint.setNewConstant(tagLabelWidht)
            tagViewWidthConstraint.setNewConstant(tagLabelWidht + 32)
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutSubviews()
            }, completion: nil)
        }
    }
    
    
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
        
        self.descriptionLabel.font = AppFonts.normalBold
        self.tagLabel.font =  AppFonts.small
        self.titleLabel.font = AppFonts.normalBold
        self.addressLabel.font = AppFonts.normal
        self.roundedBorder(value: 5.0)
        self.addShadow()
    }
    
    
    func resizeTagView(){
        if let width = tagLabel.text?.getLabelWidth(font: AppFonts.small){
            tagLabelWidht = width
            
        }
    }
    
    
}


