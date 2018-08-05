//
//  NewAdViewController.swift
//  GlobalPages
//
//  Created by Nour  on 8/4/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NewAdViewController: AbstractController {

    
    // outlates
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adtitleTextField: UITextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var imagesTitleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var adCategoryTitleLabel: UILabel!
    
    @IBOutlet weak var adCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategortTitleLabel: UILabel!
    
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var hideAbleView1: UIView!
    @IBOutlet weak var hideAbelView2: UIView!
    @IBOutlet weak var addButton: XUIButton!
    
    
    let cellId = "filterCell2"
    let imageCellId = "ImageCell"
    var images:[UIImage] = [#imageLiteral(resourceName: "AI_Image"),#imageLiteral(resourceName: "profile_image")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setNavBarTitle(title: "Add New Ad")
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
    }
    
    override func customizeView() {
        super.customizeView()
        
        // fonts
        self.adTitleLabel.font = AppFonts.big
        self.adtitleTextField.font = AppFonts.xBigBold
        self.descriptionTitleLabel.font = AppFonts.big
        self.descriptionTextView.font = AppFonts.xBigBold
        self.imagesTitleLabel.font = AppFonts.big
        self.adCategoryTitleLabel.font = AppFonts.big
        self.subCategortTitleLabel.font = AppFonts.big
        self.cityTitleLabel.font = AppFonts.big
        self.areaTitleLabel.font = AppFonts.big
        self.addButton.titleLabel?.font = AppFonts.bigBold
    
        // texts
        self.adtitleTextField.placeholder = "AD_NEW_TITLE_TEXT_FIELD_PLACEHOLDER".localized
        self.descriptionTextView.placeholder = "AD_NEW_DESCRIPTION_PLCAEHOLDER".localized
        
        setupCollectionViews()
    }
    
    func setupCollectionViews(){
        
        let nib = UINib(nibName: cellId, bundle: nil)
        
        self.adCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.cityCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.areaCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        
        let imageNib = UINib(nibName: imageCellId, bundle: nil)
        self.imageCollectionView.register(imageNib, forCellWithReuseIdentifier: imageCellId)
        
    }

    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension NewAdViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView{
            return images.count
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
            if indexPath.item < images.count{
                cell.image = images[indexPath.item]
                cell.editMode()
            }else{
                cell.image = #imageLiteral(resourceName: "ic_add")
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension NewAdViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView{
            return CGSize(width: 75, height: 75)
        }
        return CGSize(width: 0, height: 0)
    }
    
    
}


