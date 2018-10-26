//
//  NewProductViewController.swift
//  GlobalPages
//
//  Created by Nour  on 8/10/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NewProductViewController: AbstractController {

    @IBOutlet weak var infoLabel: XUILabel!
    @IBOutlet weak var iamgeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTitleLabel: XUILabel!
    @IBOutlet weak var nameTextField: XUITextField!
    @IBOutlet weak var descritionTitleLabel: XUILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var applyButton: XUIButton!
    
    var tempProduct:Product?
    var bussinessId:String?
    var image:UIImage?
    var editMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.showNavBackButton = true
        
        if let product = tempProduct{
            fillData(product: product)
            editMode = true
        }else{
            tempProduct = Product()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.applyButton.applyStyleGredeant()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func customizeView() {
        self.infoLabel.font = AppFonts.small
        self.nameTitleLabel.font = AppFonts.normal
        self.descritionTitleLabel.font = AppFonts.normal
        self.nameTextField.font = AppFonts.bigBold
        self.descriptionTextView.font = AppFonts.bigBold
        self.applyButton.titleLabel?.font = AppFonts.bigBold
        
        self.nameTextField.placeholder = "NEW_PRODUCT_NAME_PLACEHOLDER".localized
        self.descriptionTextView.placeholder = "NEW_PRODUCT_DESC_PLACEHOLDER".localized
        self.applyButton.setTitle("NEW_PRODUCT_APPLY_BTN".localized, for: .normal)
    }
    
    
    func fillData(product:Product){
        if let title = product.name{ self.nameTextField.text = title}
        if let desc = product.description { self.descriptionTextView.text = desc ; self.descriptionTextView.placeholder = nil}
        if let image = product.image { self.imageView.setImageForURL(image, placeholder: nil)}
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
            takePhoto()
    }
    
    override func setImage(image: UIImage) {
        self.image = image
        self.imageView.image = image
        
    }
    
    func vlaidate()->Bool{
        
        if let name = nameTextField.text , !name.isEmpty{
            tempProduct?.name = name
        }else{
            self.showMessage(message: "Please Enter a name".localized, type: .error)
            return false
        }
        
        if let desc = descriptionTextView.text , !desc.isEmpty{
            tempProduct?.description = desc
        }else{
            tempProduct?.description = nil
        }
        
        return true
    }
  
    
    @IBAction func save(_ sender: UIButton) {
        if vlaidate(){
            uplaodImage()
        }
    }
    
    func uplaodImage(){
        if let image = image{
        self.showActivityLoader(true)
        ApiManager.shared.uploadImages(images: [image]) { (result, error) in
            self.showActivityLoader(false)
            if let media = result.first{
                self.tempProduct?.image = media.fileUrl
                self.saveProduct()
            }
            }
        }else{
            self.saveProduct()
        }
        
    }
    
    func saveProduct(){
        self.showActivityLoader(true)
        if editMode{
            ApiManager.shared.editProduct(product: tempProduct!, bussinessId: bussinessId ?? "", completionBlock: { (success, error) in
                self.showActivityLoader(false)
                if success{
                    self.showMessage(message: "Done".localized, type: .success)
                }
                if error != nil{self.showMessage(message: "error".localized, type: .error)}
            })
        }
        else{
        ApiManager.shared.addProduct(product: tempProduct!, bussinessId: bussinessId ?? "", completionBlock: { (success, error) in
            self.showActivityLoader(false)
            if success{
                self.showMessage(message: "Done".localized, type: .success)
            }
            if error != nil{self.showMessage(message: "error".localized, type: .error)}
        })
        }

    }
    
    
    

}
