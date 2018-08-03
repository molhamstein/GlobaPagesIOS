//
//  BussinessGuidListCell.swift
//  GlobalPages
//
//  Created by Nour  on 7/22/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit


protocol BussinessGuidListCellDelegate {
    func showDetails(bussinesGuide:String) // here should be a modle of typ bussines guid
}

class BussinessGuidListCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bussinessGuideTitleLabel: UILabel!
    @IBOutlet weak var bussinessGuideCategoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    
    var delegate:BussinessGuidListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // fonts
        self.tagLabel.font = AppFonts.smallBold
        self.bussinessGuideTitleLabel.font = AppFonts.normal
        self.bussinessGuideCategoryLabel.font = AppFonts.small
        // color
        self.bussinessGuideCategoryLabel.textColor = .black
        self.bussinessGuideCategoryLabel.textColor = AppColors.grayLight
    }

    
    
    
    @IBAction func detailsButtonClicked(_ sender: UIButton) {
    }
    
}




