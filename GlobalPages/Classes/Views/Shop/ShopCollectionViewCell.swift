//
//  ShopCollectionViewCell.swift
//  Vobble
//
//  Created by Bayan on 3/5/18.
//  Copyright © 2018 Brain-Socket. All rights reserved.
//

import UIKit


class ShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shadowHolderView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!

    var shadowApplied: Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = AppFonts.xBigBold
        priceLabel.font = AppFonts.xBigBold
        descriptionLabel.font = AppFonts.small
        buyButton.titleLabel?.font = AppFonts.normalBold
        
        buyButton.setTitle("SHOP_BTN_BUY".localized, for: .normal)
        // Initialization
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configCell() {
        
//        mainView.removeGradientLayer()
//        mainView.applyGradient(colours: [shopItemObj.firstColor, shopItemObj.secondColor], direction: .horizontal)
//        titleLabel.text = shopItemObj.title
//        priceLabel.text = shopItemObj.price
//        descriptionLabel.text = shopItemObj.description
//        if let iconUrl = shopItemObj.icon {
//            image.sd_setImage(with: URL(string:iconUrl))
//        }
//
//        dispatch_main_after(0.2) {
//            if !self.shadowApplied {
//                self.shadowHolderView.dropShortShadow()
//                self.shadowApplied = true
//            }
//        }
    }

    
}
