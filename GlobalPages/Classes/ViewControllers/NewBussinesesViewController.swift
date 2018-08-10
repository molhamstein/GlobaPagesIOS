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
    
    
    let cellId = "filterCell2"
    let imageCellId = "ImageCell"
    var images:[UIImage] = [#imageLiteral(resourceName: "AI_Image"),#imageLiteral(resourceName: "profile_image")]
    
    var filters:[String] = ["Restaurants","Medicine","Pharmacy"]
    var subfilters:[String] = ["Eye","Shawrma","Fast Food"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarTitle(title: "Add New Bussiness")
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.showNavBackButton = true
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
        self.adtitleTextField.placeholder = "Email"
        self.descriptionTextView.placeholder = "(Optional)"
        self.faxTextView.placeholder = "(Optional)"
        self.phonenumber1TextField.placeholder = "(Optional)"
        self.phonenumber2TextField.placeholder = "(Optional)"
        self.locationTextField.placeholder = "(Optional)"
        
        self.locationTextField.addIconButton(image: "ic_nearby")
        
        setupCollectionViews()
    }
    
    func setupCollectionViews(){
        
        let nib = UINib(nibName: cellId, bundle: nil)
        
        self.adCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
//        self.cityCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
//        self.areaCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
//
        let imageNib = UINib(nibName: imageCellId, bundle: nil)
        self.imageCollectionView.register(imageNib, forCellWithReuseIdentifier: imageCellId)
        
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        //self.dismiss(animated: true, completion: nil)
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    @IBAction func addBusinessAction(_ sender: AnyObject) {
        //self.popOrDismissViewControllerAnimated(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
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
            return filters.count
        }
        
        if collectionView == self.subCategoryCollectionView{
            return subfilters.count
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
            cell.title = filters[indexPath.item]
            collectionView.deselectItem(at: indexPath, animated: true)
            cell.isSelected = false
            cell.setupView(type: .normal)
            return cell
        }
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! filterCell2
            cell.title = subfilters[indexPath.item]
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
            let width = filters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 32
            return CGSize(width: width, height: height)
        }
        
        if collectionView == subCategoryCollectionView{
            let height = self.subCategoryCollectionView.bounds.height - 24
            let width = subfilters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 32
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
        cell.isSelected = true
        cell.configureCell()
        }
        
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            cell.isSelected = true
            cell.configureCell()
        }
        
        if collectionView == imageCollectionView{
            if indexPath.item == images.count{
                takePhoto()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
        cell.isSelected = false
        cell.configureCell()
    }

}


// image handleras
extension NewBussinesesViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
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


