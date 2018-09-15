//
//  NewAdViewController.swift
//  GlobalPages
//
//  Created by Nour  on 8/4/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NewBussinesesViewController: AbstractController {
    
    
    // outlates
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adtitleTextField: UITextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var imagesTitleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var phonenumber1TitleLabel: XUILabel!
    @IBOutlet weak var phonenumber1TextField: XUITextField!
    @IBOutlet weak var phonenumber2TitleLabel: XUILabel!
    @IBOutlet weak var phonenumber2TextField: XUITextField!
    
    @IBOutlet weak var adCategoryTitleLabel: UILabel!
    
    @IBOutlet weak var adCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategortTitleLabel: UILabel!
    
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var locationTextField: XUITextField!
    
    @IBOutlet weak var locationTitleLabel: XUILabel!
    @IBOutlet weak var faxTitleLabel: XUILabel!
    @IBOutlet weak var faxTextView: UITextView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var hideAbleView1: UIView!
    @IBOutlet weak var hideAbelView2: UIView!
    @IBOutlet weak var addButton: XUIButton!
    @IBOutlet weak var subCategoryHeightConstraint: NSLayoutConstraint!
    
    var subCategoryViewHeight:CGFloat = 0{
        didSet{
            subCategoryHeightConstraint.setNewConstant(subCategoryViewHeight)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutSubviews()
            }, completion: nil)
        }
    }
    
    let cellId = "filterCell2"
    let imageCellId = "ImageCell"
    var images:[UIImage] = []
    var media:[Media] = []
    
    var selectedCategory:Category?
    var selectedSubCategory:Category?
    
    var categoryfilters:[Category]{
        return DataStore.shared.categories.filter { $0.parentCategoryId == nil }
    }
    var subCategoryFilters:[Category] {
        if let cat = selectedCategory {
            return DataStore.shared.categories.filter({$0.parentCategoryId == cat.Fid}) }
        return []
    }
    
    var categoriesCount = 0
    var subCategoriesCount = 0
    
    var tempBussiness:Bussiness?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subCategoryViewHeight = 0
        self.setNavBarTitle(title: "Add New Bussiness")
        
        if let bussiness = tempBussiness{
           // fillPostData(post: post)
            print(bussiness.dictionaryRepresentation())
        }
        else{
            tempBussiness = Bussiness()
        }
        getBussinessFilters()
        self.subCategoryView.isHidden = false
        
    
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
        self.phonenumber1TitleLabel.font = AppFonts.big
        self.phonenumber1TextField.font = AppFonts.xBigBold
        self.phonenumber2TitleLabel.font = AppFonts.big
        self.phonenumber2TextField.font = AppFonts.xBigBold
        self.locationTextField.font = AppFonts.xBigBold
        self.faxTitleLabel.font = AppFonts.big
        self.faxTextView.font = AppFonts.xBigBold
        self.addButton.titleLabel?.font = AppFonts.bigBold
        
        // texts
        self.adtitleTextField.placeholder = "Name".localized
        self.descriptionTextView.placeholder = "(Optional)".localized
        self.faxTextView.placeholder = "(Optional)".localized
        self.phonenumber1TextField.placeholder = "(Optional)".localized
        self.phonenumber2TextField.placeholder = "(Optional)".localized
        self.locationTextField.placeholder = "(Optional)".localized
        
        self.locationTextField.addIconButton(image: "ic_nearby")
        
        setupCollectionViews()
    }
    
    
    func getBussinessFilters(){
        self.showActivityLoader(true)
        ApiManager.shared.businessCategories { (success, error, result , cats) in
            self.showActivityLoader(false)
            if success{
                DataStore.shared.categories = cats
                self.categoriesCount = self.categoryfilters.count
                self.adCategoryCollectionView.reloadData()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    func getSubCategories(){
        self.subCategoriesCount = self.subCategoryFilters.count
        subCategoryCollectionView.reloadData()
        subCategoryCollectionView.collectionViewLayout.invalidateLayout()
        subCategoryCollectionView.layoutSubviews()
        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryViewHeight  = 100
        }){ (success) in}
    }
    
    func hideSubCategoryView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryViewHeight  = 0
        }){ (success) in}
    }
    
    func setupCollectionViews(){
        
        let nib = UINib(nibName: cellId, bundle: nil)
        
        self.adCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)

        let imageNib = UINib(nibName: imageCellId, bundle: nil)
        self.imageCollectionView.register(imageNib, forCellWithReuseIdentifier: imageCellId)
        
    }
    
    
    func validate()-> Bool{
        
        
        if let title = adtitleTextField.text , !title.isEmpty{
            if AppConfig.currentLanguage == .arabic{ tempBussiness?.nameAr = title}
            else{ tempBussiness?.nameEn = title}
        }else{
            self.showMessage(message: "please Enter a name to your Bussiness".localized, type: .error)
            return false
        }
        
        if let phone = phonenumber1TextField.text , !phone.isEmpty{
            
        }else{
            
        }
        
        if let phone2 = phonenumber2TextField.text , !phone2.isEmpty{
            
        }else{
            
        }
        
        
        if let cat = selectedCategory {
            tempBussiness?.categoryId = cat.Fid
        }else{
            self.showMessage(message: "please select a category to your add".localized, type: .error)
            return false
        }
        
        
        if let cat = selectedSubCategory {
            tempBussiness?.subCategoryId = cat.Fid
        }else{
            self.showMessage(message: "please select a subCategory to your add".localized, type: .error)
            return false
        }
        
    
        if let desc = descriptionTextView.text , !desc.isEmpty{
            tempBussiness?.description = desc
        }else{
            tempBussiness?.description = nil
        }
        
        tempBussiness?.ownerId = DataStore.shared.me?.objectId
        return true
    }
    
    
    func uploadImages(){
        self.showActivityLoader(true)
        ApiManager.shared.uploadImages(images: self.images) { (urls, error) in
            self.media = urls
            self.addBussiness()
        }
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBusinessAction(_ sender: AnyObject) {
        if validate(){
            uploadImages()
        }
    }
    
    func addBussiness(){
        ApiManager.shared.addBussiness(bussiness: tempBussiness!) { (success, error) in
            if success{
                self.showMessage(message: "Done".localized, type: .success)
            }
            if error != nil{}
        }
    }
}


extension NewBussinesesViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView{
            return images.count + 1
        }
        
        if collectionView == self.adCategoryCollectionView{
            return categoryfilters.count
        }
        
        if collectionView == self.subCategoryCollectionView{
            return subCategoryFilters.count
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
        
        if collectionView == adCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! filterCell2
            cell.title = categoryfilters[indexPath.item].title ?? ""
            collectionView.deselectItem(at: indexPath, animated: true)
            cell.isSelected = false
            cell.setupView(type: .normal)
            return cell
        }
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! filterCell2
            cell.title = subCategoryFilters[indexPath.item].title ?? ""
            collectionView.deselectItem(at: indexPath, animated: true)
            cell.isSelected = false
            cell.setupView(type: .normal)
            return cell
        }
        return UICollectionViewCell()
    }

}

extension NewBussinesesViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView{
            let height = self.imageCollectionView.bounds.height - 16
            return CGSize(width: height, height: height)
        }
        
        if collectionView == adCategoryCollectionView{
            let height = self.adCategoryCollectionView.bounds.height - 24
            let width = (categoryfilters[indexPath.item].title?.getLabelWidth(font: AppFonts.normal))! + 32
            return CGSize(width: width, height: height)
        }
        
        if collectionView == subCategoryCollectionView{
            let height = self.subCategoryCollectionView.bounds.height - 24
            let width = (subCategoryFilters[indexPath.item].title?.getLabelWidth(font: AppFonts.normal))! + 32
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == adCategoryCollectionView{
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            if collectionView == adCategoryCollectionView {
                if let value = selectedCategory{
                    if value.Fid == categoryfilters[indexPath.item].Fid{
                        cell.isSelected = false
                        selectedCategory = nil
                        collectionView.deselectItem(at: indexPath, animated: true)
                        self.hideSubCategoryView()
                    }else{
                        selectedCategory = categoryfilters[indexPath.item]
                        cell.isSelected = true
                        self.getSubCategories()
                    }
                }else{
                    selectedCategory = categoryfilters[indexPath.item]
                    cell.isSelected = true
                    self.getSubCategories()
                }
            }
        }
            if collectionView == subCategoryCollectionView{
                let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
                if let value = selectedSubCategory{
                    if value.Fid == subCategoryFilters[indexPath.item].Fid{
                        selectedSubCategory = nil
                        cell.isSelected = false
                        collectionView.deselectItem(at: indexPath, animated: true)
                    }else{
                        selectedSubCategory = subCategoryFilters[indexPath.item]
                        cell.isSelected = true
                    }
                }else{
                    selectedSubCategory = subCategoryFilters[indexPath.item]
                    cell.isSelected = true
                }
            }
        
        if collectionView == imageCollectionView{
            if indexPath.item == images.count{
                takePhoto()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
        if collectionView == adCategoryCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            selectedCategory = nil
            cell.isSelected = false
            cell.configureCell()
        }
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            selectedSubCategory = nil
            cell.isSelected = false
            cell.configureCell()
        }
        
    
    }

}


// image handleras
extension NewBussinesesViewController {

    override func setImage(image: UIImage) {
        images.append(image)
        self.imageCollectionView.reloadData()
    }
    
    
}



