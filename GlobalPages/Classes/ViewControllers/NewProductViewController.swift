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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.showNavBackButton = true
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
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        
    }
    
  

}
