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




