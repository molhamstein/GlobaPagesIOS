//
//  SkillCollectionViewCell.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/23/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

protocol SkillCollectionViewDelegate: class {
    func didTabOnRemove(_ cell: SkillCollectionViewCell)
}
class SkillCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnRemove: UIButton!

    var delegate: SkillCollectionViewDelegate?
    
    var title:String = ""{
        didSet{
            self.titleLabel.text = title
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = AppFonts.normal
        titleLabel.sizeToFit()
        self.perform(#selector(setupView), with: nil, afterDelay: 0.3)
        
    }
    
    @objc func setupView(){
        self.makerounded()
    
    }
    
    @IBAction func RemoveAction(_ sender: Any) {
        self.delegate?.didTabOnRemove(self)
    }
}
