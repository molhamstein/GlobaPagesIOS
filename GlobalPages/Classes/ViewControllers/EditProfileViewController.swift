//
//  EditProfileViewController.swift
//  GlobalPages
//
//  Created by Nour  on 9/6/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class EditProfileViewController: AbstractController {

    @IBOutlet weak var mainView: UIView!
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
    @IBOutlet weak var birthDateView: UIView!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var signupView: UIScrollView!
    @IBOutlet weak var updateButton: UIButton!
    
    // Data
    var tempUserInfoHolder: AppUser = AppUser()
    var password: String = ""
    var birthdate: Date?
    
     var isInitialized = false
    var viewType:ViewType = .login
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isInitialized {
            self.signupView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.signupView.frame.height)
            self.birthDateView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.birthDateView.frame.height)
            dispatch_main_after(0.7) {
                self.showView(withType: .signup)
            }
        }
        isInitialized = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
            self.mainView.applyStyleGredeant()
            self.updateButton.applyStyleGredeant()
     
    }
    
    override func customizeView() {
        super.customizeView()
        self.setNavBarTitle(title: "Edit Profile".localized)
        
        self.usernameTitleLabel.font = AppFonts.normal
        self.usernameTextField.font = AppFonts.xBigBold
        self.emailTitleLabel.font = AppFonts.normal
        self.emailTextField.font = AppFonts.xBigBold
//        self.passwordTitleLabel.font = AppFonts.normal
//        self.passwordtextField.font = AppFonts.xBigBold
        self.birthDateButton.titleLabel?.font = AppFonts.xBigBold
        self.maleLabel.font = AppFonts.normalBold
        self.femaleLabel.font = AppFonts.normalBold
        
        
        birthDatePicker.addTarget(self, action: #selector(birthdateChanged(_:)), for: .valueChanged)
        
        fillUserData()
    }
    
    
    func fillUserData(){
        guard let user = DataStore.shared.me else {return}
        tempUserInfoHolder = user
        if let username = user.userName {self.usernameTextField.text = username}
        if let email = user.email{self.emailTextField.text = email}
        if let image = user.profilePic { self.imageView.setImageForURL(image, placeholder: #imageLiteral(resourceName: "image_placeholder"))}
        if let birthDate = user.birthdate {
            birthDateButton.setTitle(DateHelper.getBirthFormatedStringFromDate(birthDate), for: .normal)
            self.birthdate = birthDate
        }
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
        takePhoto()
    }
    
    @IBAction func update(_ sender: UIButton) {
    }
    
    override func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
    @IBAction func CancelBtnPressed(_ sender: Any) {
        hideView(withType: .countryV)
    }
    
    @IBAction func pickDatePressed(_ sender: Any) {
        hideView(withType: .countryV)
        if let date = birthdate{
            self.birthDateButton.setTitle(DateHelper.getBirthFormatedStringFromDate(date), for: .normal)
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        hideView(withType: .countryV)
        if let date = birthdate{
            self.birthDateButton.setTitle(DateHelper.getBirthFormatedStringFromDate(date), for: .normal)
        }
    }
    
    
    @IBAction func dateBtnPressed(_ sender: UIButton) {
        showView(withType: .countryV)
    }
    

    func validateFields () -> Bool {
    
        // validate email
        if let email = emailTextField.text, !email.isEmpty {
        } else {
            showMessage(message:"SINGUP_VALIDATION_EMAIL".localized, type: .warning)
            return false
        }
        
        if emailTextField.text!.isValidEmail() {
            tempUserInfoHolder.email = emailTextField.text!
        } else {
            showMessage(message:"SINGUP_VALIDATION_EMAIL_FORMAT".localized, type: .warning)
            return false
        }
        
        if let uName = usernameTextField.text, !uName.isEmpty {
            tempUserInfoHolder.userName = uName
        } else {
            showMessage(message:"SINGUP_VALIDATION_FNAME".localized, type: .warning)
            return false
        }
        
        tempUserInfoHolder.gender = isMale ? .male : .female
       
     
    
        // validate password
//        if let psw = passwordtextField.text, !psw.isEmpty {
//        } else {
//            showMessage(message:"SINGUP_VALIDATION_PASSWORD".localized, type: .warning)
//            return false
//        }
//
//        if svPasswordTextField.text!.length >= AppConfig.passwordLength {
//            password = svPasswordTextField.text!;
//        } else {
//            showMessage(message:"SINGUP_VALIDATION_PASSWORD_LENGHTH".localized, type: .warning)
//            return false
//        }
        
        if let birthdate = birthdate {
            
            // make sure selected date is valid
            // picked birthadate should be earlier than 12 years from now
            let calendar = NSCalendar.current
            let date2yearsOld = calendar.date(byAdding: .year, value: -12, to: Date())
            let date100yearsOld = calendar.date(byAdding: .year, value: 100, to: Date())
            
            if date2yearsOld!.compare(birthdate) == .orderedAscending {
                showMessage(message:"SINGUP_VALIDATION_DATE".localized, type: .warning)
                return false
            }
            
            if birthdate.compare(date100yearsOld!) == .orderedDescending {
                showMessage(message:"SINGUP_VALIDATION_DATE".localized, type: .warning)
                return false
            }
            
            // date is valid
            tempUserInfoHolder.birthdate = birthdate
        } else {
            showMessage(message:"SINGUP_VALIDATION_CHOOSE_BIRTHDATE".localized, type: .warning)
            return false
        }
        return true
    }
    
    // MARK: textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordtextField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    func showView(withType:ViewType) {
        switch withType {
        case .signup :
            signupView.dropShadow()
            UIView.animate(withDuration: 0.4, delay:0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.signupView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            }, completion: {(finished: Bool) in
                self.viewType = .signup
            })
        case .countryV :
            signupView.dropShadow()
            UIView.animate(withDuration: 0.4, delay:0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.birthDateView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            }, completion: {(finished: Bool) in
                
            })
        default:
            break
        }
    }
    
    
    
    func hideView(withType:ViewType) {
        switch withType {
        case .signup :
            UIView.animate(withDuration: 0.3, delay:0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.signupView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.signupView.frame.height)
            }, completion: {(finished: Bool) in
                
            })
        case .countryV :
            UIView.animate(withDuration: 0.3, delay:0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.birthDateView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.birthDateView.frame.height)
            }, completion: {(finished: Bool) in
                
            })
        default:
            break
        }
    }
    
    @IBAction func updateUser(_ sender: UIButton) {
        if validateFields(){
            self.showActivityLoader(true)
            uploadImage()
        }
        
    }
    
    
    func updateAction(){
        ApiManager.shared.updateUser(user: tempUserInfoHolder, completionBlock: { (success, error, user) in
            self.showActivityLoader(false)
            
            if success{
                self.showMessage(message: "Done".localized, type: .success)
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        })

    }
    
    func uploadImage(){
        if let image = imageView.image{
            ApiManager.shared.uploadImages(images: [image], completionBlock: { (media, error) in
                if error != nil{
                    self.showMessage(message: error!, type: .error)
                }else{
                    if let first = media.first{
                        self.tempUserInfoHolder.profilePic = first.fileUrl
                    }
                }
                self.updateAction()
            })
        }else{
            self.updateAction()
        }
    }
}




extension EditProfileViewController{
    
    func birthdateChanged(_ sender: UIDatePicker) {
        self.birthdate = sender.date
    }
}
