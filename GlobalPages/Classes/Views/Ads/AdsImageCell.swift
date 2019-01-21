//
//  AdsCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/7/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class AdsImageCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var tagViewWidthConstraint: XNSLayoutConstraint!
    
    @IBOutlet weak var tagLabelWidthConstraint: XNSLayoutConstraint!
    
    var tagLabelWidht:CGFloat = 0 {
        didSet{
           // tagLabelWidthConstraint.setNewConstant(tagLabelWidht)
            tagViewWidthConstraint.setNewConstant(tagLabelWidht + 52)
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutSubviews()
            }, completion: nil)
        }
    }
    
    
    
    var post:Post?{
        
        didSet{
            guard let post = post else {return}
            if let image = post.media?.first , let url = image.fileUrl{
                self.imageView.setImageForURL(url, placeholder: nil)
            }
            if let category = post.category{
                self.tagLabel.text = category.title
            }
            if let title = post.title{
                self.titleLabel.text = title
            }
            if let city = post.city , let value = city.title{
                self.cityLabel.text = value
            }
            if let city = post.location , let value = city.title{
                self.areaLabel.text = value
            }
        }
        
        
    }


    var image:String?{
        didSet{
            guard let image = image else{ return}
                self.imageView.setImageForURL(image, placeholder: nil)
            }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // fonts
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
    
}

