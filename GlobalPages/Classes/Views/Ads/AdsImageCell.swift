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
    
    @IBOutlet weak var editButton: UIButton!
    
    var delegate:AdsCellDelegate?
    
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
            }else{
                self.tagLabel.text = ""
            }
            if let title = post.title{
                self.titleLabel.text = title
            }else{
                self.titleLabel.text = ""
            }
            if let city = post.city , let value = city.title{
                self.cityLabel.text = value
            }else{
                self.cityLabel.text = ""
            }
            if let city = post.location , let value = city.title{
                self.areaLabel.text = value
            }else{
                self.areaLabel.text = ""
                
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
        self.tagLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.titleLabel.font = AppFonts.normalBold
        self.titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.cityLabel.font = AppFonts.small
        self.cityLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.areaLabel.font = AppFonts.small
        self.areaLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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

