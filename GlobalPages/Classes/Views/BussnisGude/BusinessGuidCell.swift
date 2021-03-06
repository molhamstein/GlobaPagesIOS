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
    @IBOutlet weak var shadowView: UIView!
    
    
    var businessGuide:BusinessGuide?{
        
        didSet{
            guard let businessGuide = businessGuide else {
                return
            }
            self.businessInfoLabel.text = businessGuide.info
            self.imageView.image = UIImage(named:businessGuide.image)
        }
    }
    
    
    var post:Post?{
        didSet{
            guard let psot = post else{ return }
            if let image = psot.image{
                self.imageView.setImageForURL(image, placeholder: nil)
            }
            if let title = post?.title{
                self.businessInfoLabel.text = title
            }
        }
    }
    

    func setpView(colors:[UIColor]){
        dispatch_main_after(0.1) {
            self.containerView.applyGradient(colours: colors.reversed(), direction: .diagonal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.businessInfoLabel.font = AppFonts.xBigBold
        self.businessInfoLabel.dropShadow()
        self.addShadow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.shadowView.removeGradientLayer()
        self.shadowView.applyGradient(colours: [UIColor.clear, UIColor.black.withAlphaComponent(0.4)], direction: .vertical)
    }
    
}
