//
//  BussinesGuidCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/7/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class BusinessGuidCell: UICollectionViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var businessTitleLabel: UILabel!
    @IBOutlet weak var businessInfoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var businessGuide:BusinessGuide?{
        
        didSet{
            
            guard let businessGuide = businessGuide else {
                return
            }
            
            self.businessTitleLabel.text = businessGuide.title
            self.businessInfoLabel.text = businessGuide.info
            self.imageView.image = UIImage(named:businessGuide.image)
        }
        
    }
    
    var gradiantColors:[UIColor] = []{
        didSet{
            containerView.applyGradient(colours: gradiantColors.reversed(), direction: .horizontal)
        }
    }
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.businessInfoLabel.font = AppFonts.normal
        self.businessTitleLabel.font = AppFonts.xBig
        
        
    }

}
