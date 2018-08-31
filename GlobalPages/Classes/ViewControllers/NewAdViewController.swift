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
    var images:[UIImage] = []
    var media:[Media] = []
    var selectedCategory:Category?
    var selectedSubCategory:Category?
    var selectedCity:City?
    var selectedArea:City?
    var cityId = ""
    var locationId = ""
    
    var categoryfilters:[Category]{
        return DataStore.shared.categories.filter { $0.parentCategoryId == nil }
    }
    var subCategoryFilters:[Category] {
        if let cat = selectedCategory { return DataStore.shared.categories.filter({$0.parentCategoryId == cat.Fid}) }
        return []
    }
    var cities:[City] { return DataStore.shared.cities }
    var areas:[City]  {
        if let city = selectedCity { return city.locations ?? [] }
        return []
    }
    
    
    var categoriesCount = 0
    var subCategoriesCount = 0
    var citiesCount = 0
    var areasCount = 0
    
    var tempPost:Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarTitle(title: "Add New Ad".localized)
        
        
        if let post = tempPost{
            fillPostData(post: post)
        }
        else{
            tempPost = Post()
        }
    }
    
    func fillPostData(post:Post){
        if let title = post.title{ self.adTitleLabel.text = title}
        if let desc  = post.description { self.descriptionTextView.text = desc}
        if let array = post.media{
            for mediaObj in array{
                let imageView = UIImageView()
                if let url = mediaObj.fileUrl{
                    imageView.sd_setShowActivityIndicatorView(true)
                    imageView.sd_setIndicatorStyle(.gray)
                    imageView.sd_setImage(with: URL(string:url), completed: { (image, error, cach, url) in
                        if let img = image{
                            self.images.append(img)
                        }
                    })
                }
            }
            imageCollectionView.reloadData()
        }
        
        selectedCategory = post.category
        selectedSubCategory = post.subCategory
        selectedCity = post.city
        selectedArea = post.location
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
    }
    
    override func customizeView() {
        super.customizeView()
        
        self.subCategoryView.isHidden = true
        self.areaView.isHidden = true
        self.hideAbleView1.isHidden = false
        self.hideAbelView2.isHidden = false
        
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
        self.adtitleTextField.placeholder    = "AD_NEW_TITLE_TEXT_FIELD_PLACEHOLDER".localized
        self.descriptionTextView.placeholder = "AD_NEW_DESCRIPTION_PLCAEHOLDER".localized
        
        setupCollectionViews()
        getBussinessFilters()
        getCityFilters()
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
    /*
     var indexPaths: [NSIndexPath] = []
     for i in 0..<subCategoryFilters {
     indexPaths.append(NSIndexPath(item: i, section: 0))
     }
     areaCollectionView.reloadItems(at: indexPaths as [IndexPath])
     areaCollectionView.collectionViewLayout.invalidateLayout()
     */
    
    // categories and filters
    func getSubCategories(){
        self.subCategoriesCount = self.subCategoryFilters.count
        subCategoryCollectionView.reloadData()
        subCategoryCollectionView.collectionViewLayout.invalidateLayout()
        subCategoryCollectionView.layoutSubviews()

//        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryView.isHidden = false
            self.hideAbleView1.isHidden = true
//        }){ (success) in}
    }
    
    func hideSubCategoryView(){
//        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryView.isHidden = true
            self.hideAbleView1.isHidden = false
//        }){ (success) in}
    }
    
    
    func getAreas(){
        self.areasCount = self.areas.count
        areaCollectionView.reloadData()
        areaCollectionView.collectionViewLayout.invalidateLayout()
        areaCollectionView.layoutSubviews()
//        UIView.animate(withDuration: 0.2, animations: {
            self.areaView.isHidden = false
            self.hideAbelView2.isHidden = true
//        }){ (success) in}
        
    }
    func HideAreaView(){
//        UIView.animate(withDuration: 0.2, animations: {
            self.areaView.isHidden = true
            self.hideAbelView2.isHidden = false
//        }){ (success) in}
    }
    
    
    func getBussinessFilters(){
        self.showActivityLoader(true)
        ApiManager.shared.businessCategories { (success, error, result , cats) in
            self.showActivityLoader(false)
            if success{
                DataStore.shared.categories = cats
                self.categoriesCount = self.categoryfilters.count
                self.adCategoryCollectionView.reloadData()
                self.adCategoryCollectionView.collectionViewLayout.invalidateLayout()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    func getCityFilters(){
        self.showActivityLoader(true)
        ApiManager.shared.getCities { (success, error, result,cities) in
            self.showActivityLoader(false)
            if success{
                DataStore.shared.cities = cities
                self.citiesCount = self.cities.count
                self.cityCollectionView.reloadData()
                self.cityCollectionView.collectionViewLayout.invalidateLayout()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    
    func validate()-> Bool{
        
        
        if let title = adtitleTextField.text , !title.isEmpty{
            tempPost?.title = title
        }else{
            self.showMessage(message: "please Enter a title to your add".localized, type: .error)
            return false
        }
        
        
        if let desc = descriptionTextView.text , !desc.isEmpty{
            tempPost?.description = desc
        }else{
            self.showMessage(message: "please Enter a description to your add".localized, type: .error)
            return false
        }
        
        if let cat = selectedCategory {
            tempPost?.categoryId = cat.Fid
        }else{
            self.showMessage(message: "please select a category to your add".localized, type: .error)
            return false
        }
        
        
        if let cat = selectedSubCategory {
            tempPost?.subCategoryId = cat.Fid
        }else{
            self.showMessage(message: "please select a subCategory to your add".localized, type: .error)
            return false
        }
        
        if let cat = selectedCity {
            cityId = cat.Fid!
        }else{
            self.showMessage(message: "please select a city to your add".localized, type: .error)
            return false
        }

        if let cat = selectedArea {
            locationId = cat.Fid!
        }else{
            self.showMessage(message: "please select an area to your add".localized, type: .error)
            return false
        }
        
        tempPost?.ownerId = DataStore.shared.me?.objectId
        return true
    }
    
    
    @IBAction func addPost(_ sender: UIButton) {
        if validate(){
            atempToAddPost()
        }
    }
    
    
    func atempToAddPost(){
        self.showActivityLoader(true)
            ApiManager.shared.uploadImages(images: images, completionBlock: { (result, error) in
                    self.tempPost?.media = result
                    self.addPost()
            })
    }
    
    func addPost(){
        ApiManager.shared.addPost(post: tempPost!, cityId: cityId, locationId: locationId) { (success, error) in
            self.showActivityLoader(false)
            if success{
                self.showMessage(message: "Done".localized, type: .success)
            }
            if error != nil{}
        }
        
    }
    
}


extension NewAdViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == imageCollectionView        { return images.count  + 1 }
        if collectionView == adCategoryCollectionView   { return categoriesCount }
        if collectionView == subCategoryCollectionView  { return subCategoriesCount }
        if collectionView == cityCollectionView         { return citiesCount }
        if collectionView == areaCollectionView         { return areasCount }
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
        
        if collectionView == adCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
    
            if let category = selectedCategory{
                if category.Fid == categoryfilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.getSubCategories()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = categoryfilters[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            return cell
        }
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
            
            if let category = selectedSubCategory{
                if category.Fid == subCategoryFilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = subCategoryFilters[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            return cell
        }
        if collectionView == cityCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
            if let city = selectedCity{
                if city.Fid == cities[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    getAreas()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = cities[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            return cell
        }
        if collectionView == areaCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
            if let city = selectedArea{
                if city.Fid == areas[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = areas[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension NewAdViewController:UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView{
            let height = self.imageCollectionView.frame.height - 16
            
            return CGSize(width: height, height: height)
        }
        
        if collectionView == adCategoryCollectionView{
            return CGSize(width: categoryfilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.adCategoryCollectionView.frame.height - 24)
        }
        if collectionView == subCategoryCollectionView{
            return CGSize(width: subCategoryFilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.subCategoryCollectionView.frame.height - 24)
        }
        if collectionView == cityCollectionView{
            return CGSize(width: cities[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.cityCollectionView.frame.height - 24)
        }
        if collectionView == areaCollectionView{
            return CGSize(width: areas[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.areaCollectionView.frame.height - 24)
        }
        
        return CGSize(width:0, height: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == imageCollectionView{
                if indexPath.item == images.count{
                    takePhoto()
            }
        }
        else{
        
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
            
            
        }else if collectionView == subCategoryCollectionView{
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
        }else if collectionView == cityCollectionView{
            if let value = selectedCity{
                if value.Fid == cities[indexPath.item].Fid{
                    cell.isSelected = false
                    selectedCity = nil
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.HideAreaView()
                }else{
                    selectedCity = cities[indexPath.item]
                    cell.isSelected = true
                    self.getAreas()
                }
            }else{
                selectedCity = cities[indexPath.item]
                cell.isSelected = true
                self.getAreas()
            }
            
        }else if collectionView == areaCollectionView{
            if let value = selectedArea{
                if value.Fid == areas[indexPath.item].Fid{
                    selectedArea = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    selectedArea = areas[indexPath.item]
                    cell.isSelected = true
                }
            }else{
                selectedArea = areas[indexPath.item]
                cell.isSelected = true
            }
        }
            cell.configureCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == adCategoryCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            selectedCategory = nil
            cell.isSelected = false
            cell.configureCell()
        }else if collectionView == subCategoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            selectedSubCategory = nil
            cell.isSelected = false
            cell.configureCell()
        }else if collectionView == cityCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            selectedCity = nil
            cell.isSelected = false
            cell.configureCell()
        }else if collectionView == areaCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            selectedArea = nil
            cell.isSelected = false
            cell.configureCell()
        }
       
    }
}


// image handleras
extension NewAdViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func takePhoto() {
        
        let alertController  = UIAlertController(title: "Choose source", message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openGallery))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func openCamera(action: UIAlertAction){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func openGallery(action: UIAlertAction){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        
        if let updatedImage = image.updateImageOrientionUpSide() {
            images.append(updatedImage)
            imageCollectionView.reloadData()
        } else {
            images.append(image)
            self.imageCollectionView.reloadData()
        }
        self.dismiss(animated: true, completion: nil);
    }
    
    
    
}


