//
//  EditProfileViewController.swift
//  GlobalPages
//
//  Created by Nour  on 9/6/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class EditProfileViewController: AbstractController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTitleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var birthDateButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    
    
    var isMale:Bool = false{
        didSet{
            
                if isMale{
                    maleButton.alpha = 1.0
                    maleLabel.alpha = 1.0
                    femaleLabel.alpha = 0.5
                    femaleButton.alpha = 0.5
                }else{
                    maleButton.alpha = 0.5
                    maleLabel.alpha = 0.5
                    femaleLabel.alpha = 1.0
                    femaleButton.alpha = 1.0
                }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBackButton = true
    }
    
    override func customizeView() {
        super.customizeView()
        self.setNavBarTitle(title: "Edit Profile".localized)
        
        self.usernameTitleLabel.font = AppFonts.normal
        self.usernameTextField.font = AppFonts.xBigBold
        self.emailTitleLabel.font = AppFonts.normal
        self.emailTextField.font = AppFonts.xBigBold
        self.passwordTitleLabel.font = AppFonts.normal
        self.passwordtextField.font = AppFonts.xBigBold
        self.birthDateButton.titleLabel?.font = AppFonts.xBigBold
        self.maleLabel.font = AppFonts.normalBold
        self.femaleLabel.font = AppFonts.normalBold
        
        fillUserData()
    }
    
    
    func fillUserData(){
        guard let user = DataStore.shared.me else {return}
        if let username = user.userName {self.usernameTextField.text = username}
        if let email = user.email{self.emailTextField.text = email}
        if let image = user.profilePic { self.imageView.setImageForURL(image, placeholder: #imageLiteral(resourceName: "image_placeholder"))}
        if let birthDate = user.birthdate { birthDateButton.setTitle(DateHelper.getISOStringFromDate(birthDate), for: .normal)  }
        if let gender = user.gender{isMale = gender.rawValue == "male" ? true : false}
        
    }

    @IBAction func setMale(_ sender: UIButton) {
        isMale = true
    }
    @IBAction func setFemale(_ sender: UIButton) {
        isMale = false
    }
    
    @IBAction func showBirthDateView(_ sender: UIButton) {
    }
    @IBAction func setImage(_ sender: UIButton) {
    }
    
    @IBAction func update(_ sender: UIButton) {
    }
    
}
