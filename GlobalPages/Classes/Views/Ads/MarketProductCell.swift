//
//  MarketProductCell.swift
//  GlobalPages
//
//  Created by Abd Hayek on 12/30/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

protocol MarketProductCellDelegate: class {
    func didEditPressed(_ cell: MarketProductCell)
}

class MarketProductCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var priceContainar: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    
    var product: MarketProduct?
    var imageSize = CGSize()
    var delegate: MarketProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblTitle.font = AppFonts.normal
        self.lblPrice.font = AppFonts.normalSemiBold
        self.roundedBorder(value: 5.0)
        self.addShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.shadowView.removeGradientLayer()
        self.shadowView.applyGradient(colours: [UIColor.clear, UIColor.black.withAlphaComponent(0.4)], direction: .vertical)
    }

    func configureCell(_ item: MarketProduct) {
        self.product = item
        self.lblPrice.text = String(item.price ?? 0)
        self.priceContainar.isHidden = item.price == nil ? true : false
        self.lblTitle.text = item.title
        
        if (item.images?.count ?? 0) > 0 {
            self.imgProduct.setImageForURL((item.images?[0])!, placeholder: nil)
        }else {
            self.imgProduct.image = UIImage(named: "products_placeholder")
        }
        
    }
    
    @IBAction func didEditClicked(_ sender: Any){
        delegate?.didEditPressed(self)
    }
}
