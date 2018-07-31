//
//  filterCell2.swift
//  GlobalPages
//
//  Created by Nour  on 6/27/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit


enum FilterType{
    case normal
    case map
    var backGroundColor:UIColor{
        switch self {
        case .normal:
            return UIColor.white
        case .map:
            return UIColor.clear
        }
    }
    
    
    var textColor:UIColor{
        switch self {
        case .normal:
            return UIColor.black
        case .map:
            return UIColor.white
        }
    }
}

class filterCell2: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    
    
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
//        self.perform(#selector(setupView), with: nil, afterDelay: 0.3)
    }

    
    func setupView(type:FilterType){
        dispatch_main_after(0) {
            self.makerounded()
            self.addShadow()
            self.containerView.makeRounded()
            self.backGroundView.makeRounded()
            self.backGroundView.setGradientBorder(width: 1, colors: [AppColors.yellowDark,AppColors.yellowLight])
            
        }
        self.backGroundView.backgroundColor = type.backGroundColor
        self.titleLabel.textColor = type.textColor
    }
    
    func configureCell(){
        if isSelected{
            self.containerView.isHidden = false
        }else{
            self.containerView.isHidden = true
        }
    }
}
