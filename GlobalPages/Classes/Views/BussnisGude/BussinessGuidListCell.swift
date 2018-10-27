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
    func showEdit(bussiness:Bussiness)
}

class BussinessGuidListCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bussinessGuideTitleLabel: UILabel!
    @IBOutlet weak var bussinessGuideCategoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var tagView: GradientView!
    
    var bussiness:Bussiness?{
        didSet{
            guard let bussiness = bussiness else{
                return
            }
            if let value = bussiness.category?.title{self.tagLabel.text = value}
            if let value = bussiness.title{self.bussinessGuideTitleLabel.text = value}
            if let value = bussiness.description{self.bussinessGuideCategoryLabel.text = value }
            if let image = bussiness.cover {self.imageView.setImageForURL(image, placeholder: nil)}
        }
    }
    
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
        
       // self.addShadow()
    }

    
    
    
    @IBAction func detailsButtonClicked(_ sender: UIButton) {
        
    }
    @IBAction func edit(_ sender: UIButton) {
        delegate?.showEdit(bussiness: bussiness!)
        print("sdsd")
    }
    
    
    func profileMode(){
        self.tagView.isHidden = true
        self.nextButton.isHidden = true
        self.editButton.isHidden = false
        self.addShadow()
    }
}





