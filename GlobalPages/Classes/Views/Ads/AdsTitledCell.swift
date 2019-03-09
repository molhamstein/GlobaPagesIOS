//
//  AdsCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/7/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

protocol AdsCellDelegate {
    func showEdit(post:Post)
}

class AdsTitledCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var tagViewWidthConstraint: XNSLayoutConstraint!
    @IBOutlet weak var tagLabelWidthConstraint: XNSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIButton!
    
    var delegate:AdsCellDelegate?
    
    var tagLabelWidht:CGFloat = 0 {
        didSet{
//             tagLabelWidthConstraint.setNewConstant(tagLabelWidht + 32)
            if AppConfig.currentLanguage == .arabic{
                tagViewWidthConstraint.setNewConstant(tagLabelWidht + 56)
            }else{
                tagViewWidthConstraint.setNewConstant(tagLabelWidht + 32)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutSubviews()
            }, completion: nil)
        }
    }
    
    
    var post:Post?{
        didSet{
            guard let post = post else {
                return
            }
            if let title = post.title{
                self.titleLabel.text = title
            }
            if let category = post.category{
                self.tagLabel.text = category.title
            }
            if let description = post.description{
                self.descriptionLabel.text = description
            }
            if let city = post.city , let value = city.title{
                self.cityLabel.text = value
            }
            if let city = post.location , let value = city.title{
                self.areaLabel.text = value
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // fonts
        self.descriptionLabel.font = AppFonts.normalBold
        self.tagLabel.font =  AppFonts.small
        self.titleLabel.font = AppFonts.normalBold
        self.cityLabel.font = AppFonts.normal
        self.areaLabel.font = AppFonts.normal
        self.roundedBorder(value: 5.0)
        self.addShadow()
    }
    
    
    func resizeTagView(){
        if let width = tagLabel.text?.getLabelWidth(font: AppFonts.small){
        tagLabelWidht = width
        }
    }
    
    @IBAction func edit(){
        guard let post = self.post else{return}
        delegate?.showEdit(post: post)
    }
    
    func editMode(){
        self.editButton.isHidden = false
    }
}


