//
//  filterCell2.swift
//  GlobalPages
//
//  Created by Nour  on 6/27/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class filterCell2: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override var isSelected: Bool {
        didSet {
            configureCell()
        }
    }
    
    
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

    
    func setupView(){
        self.makerounded()
        self.addShadow()
        self.containerView.makeRounded()
    }
    
    
    func configureCell(){
        if isSelected{
            self.containerView.backgroundColor = .clear
        }else{
            self.containerView.backgroundColor = .white
        }
    }
}
