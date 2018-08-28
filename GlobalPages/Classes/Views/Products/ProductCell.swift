//
//  ProductCell.swift
//  GlobalPages
//
//  Created by Nour  on 8/14/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    
    var product:Product?{
        
        didSet{
            guard let product = product else{return}
            
            if let title = product.name{
                self.titleLabel.text = title
            }
            if let image = product.image {
                imageView.setImageForURL(image, placeholder: nil)
            }
            if let price = product.price{
                self.subTitleLabel.text = "\(price)"
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = AppFonts.big
        self.subTitleLabel.font = AppFonts.normal
        self.addShadow()
        self.roundedBorder(value: 5)
    }
    
    @IBAction func edit(_ sender: UIButton) {
    }
    
    func editMode(){
        self.editButton.isHidden = false
    }
    

}
