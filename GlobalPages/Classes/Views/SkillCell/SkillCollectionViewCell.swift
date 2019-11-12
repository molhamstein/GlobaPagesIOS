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
    @IBOutlet weak var mainView: UIView!

    var delegate: SkillCollectionViewDelegate?
    
    var title:String = ""{
        didSet{
            self.titleLabel.text = title
        }
        
    }
    
    var isSelect: Bool = false {
        didSet{
            if isSelect {
                self.mainView.backgroundColor = #colorLiteral(red: 0.9472660422, green: 0.7570980191, blue: 0, alpha: 1)
                self.titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.mainView.layer.borderWidth = 0
                
            }else {
                self.mainView.backgroundColor = UIColor.clear
                self.titleLabel.textColor = #colorLiteral(red: 0.9472660422, green: 0.7570980191, blue: 0, alpha: 1)
                self.mainView.layer.borderWidth = 0.5
                self.mainView.layer.borderColor = #colorLiteral(red: 0.9472660422, green: 0.7570980191, blue: 0, alpha: 1)
                self.mainView.cornerRadius = self.frame.height / 2
            }
            
            self.layoutIfNeeded()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = AppFonts.normal
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        
        self.addShadow()
        self.makerounded()
        
        let additionalWidth: CGFloat = self.btnRemove.isHidden ? 32 : 64
        self.frame.size = CGSize(width: self.title.getLabelWidth(font: AppFonts.normal) + additionalWidth, height: self.frame.height)
    }
    
    @IBAction func RemoveAction(_ sender: Any) {
        self.delegate?.didTabOnRemove(self)
    }
}
