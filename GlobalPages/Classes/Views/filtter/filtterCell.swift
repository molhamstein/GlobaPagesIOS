//
//  filtterCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/8/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class filtterCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.perform(#selector(setupView), with: nil, afterDelay: 0.3)
    }

    func setupView(){
        
        self.makerounded()
        self.addShadow()
        
    }

}



extension UICollectionViewCell{
    
    
    func makerounded(){
        
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
    }
    
    func addShadow(){
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
    
}
