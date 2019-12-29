//
//  EditCVViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/24/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class EditCVViewController: AbstractController {
    
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblSpecialtyTitle: UILabel!
    @IBOutlet weak var lblBioTitle: UILabel!
    @IBOutlet weak var lblContactTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblPhoneTitle: UILabel!
    @IBOutlet weak var lblExperienceTitle: UILabel!
    @IBOutlet weak var lblSkillsTitle: UILabel!
    @IBOutlet weak var lblEducationTitle: UILabel!
    @IBOutlet weak var lblReferenceTitle: UILabel!
    @IBOutlet weak var lblCityTitle: UILabel!
    
    @IBOutlet weak var btnChangePic: UIButton!
    @IBOutlet weak var btnAddExperience: UIButton!
    @IBOutlet weak var btnAddEducation: UIButton!
    @IBOutlet weak var btnAddSkills: UIButton!
    @IBOutlet weak var btnAddRefernce: UIButton!
    @IBOutlet weak var btnSave: XUIButton!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtSpecialty: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var txtFacebook: UITextField!
    @IBOutlet weak var txtBehance: UITextField!
    @IBOutlet weak var txtGithub: UITextField!
    @IBOutlet weak var txtTwitter: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    
    @IBOutlet weak var imgUserPhoto: UIImageView!

    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var educationTableView: UITableView!
    @IBOutlet weak var skillCollectionView: UICollectionView!
    @IBOutlet weak var cityCollectionView: UICollectionView!

    @IBOutlet weak var experienceTableViewConstant: NSLayoutConstraint!
    @IBOutlet weak var educationTableViewConstant: NSLayoutConstraint!
    @IBOutlet weak var skillCollectionViewConstant: NSLayoutConstraint!

    fileprivate var experiences: [Experience] = []
    fileprivate var educations: [Education] = []
    fileprivate var tags: [Tag] = []
    fileprivate var tableViewRowHeight: CGFloat = 72
    fileprivate var tempCV: CV = CV()
    fileprivate var selectedCity: City?
    fileprivate var fixedWidth: CGFloat = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        self.educationTableViewConstant.constant = self.educationTableView.contentSize.height
        self.experienceTableViewConstant.constant = self.experienceTableView.contentSize.height
        self.skillCollectionViewConstant.constant = self.skillCollectionView.contentSize.height
        
        // Setup txtBio frame
        self.fixedWidth = (self.view.frame.width * 0.7)
        
        let newSize = txtBio.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtBio.translatesAutoresizingMaskIntoConstraints = true
        txtBio.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        txtBio.isScrollEnabled = false
        txtBio.delegate = self
    }

    override func buildUp() {
        experienceTableView.delegate = self
        experienceTableView.dataSource = self
        educationTableView.delegate = self
        educationTableView.dataSource = self
        skillCollectionView.delegate = self
        skillCollectionView.dataSource = self
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        
        experienceTableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        educationTableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        skillCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        cityCollectionView.register(UINib(nibName: "filterCell2", bundle: nil), forCellWithReuseIdentifier: FiltersViewController.filtterCellId)
        
        skillCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: AppConfig.currentLanguage == .arabic ? .right : .left, verticalAlignment: .top)
        
        experienceTableView.rowHeight = tableViewRowHeight
        educationTableView.rowHeight = tableViewRowHeight
        
        fillUpData()
        
        
        
    }
    
    override func customizeView() {
        lblNameTitle.font = AppFonts.normal
        lblSpecialtyTitle.font = AppFonts.normal
        lblBioTitle.font = AppFonts.normal
        lblContactTitle.font = AppFonts.bigBold
        lblEmailTitle.font = AppFonts.normal
        lblPhoneTitle.font = AppFonts.normal
        lblExperienceTitle.font = AppFonts.bigBold
        lblSkillsTitle.font = AppFonts.bigBold
        lblEducationTitle.font = AppFonts.bigBold
        lblReferenceTitle.font = AppFonts.bigBold
        lblCityTitle.font = AppFonts.normal
        
        btnChangePic.titleLabel?.font = AppFonts.normalSemiBold
        btnAddExperience.titleLabel?.font = AppFonts.normalSemiBold
        btnAddEducation.titleLabel?.font = AppFonts.normalSemiBold
        btnAddSkills.titleLabel?.font = AppFonts.normalSemiBold
        btnAddRefernce.titleLabel?.font = AppFonts.normalSemiBold
        
        txtUsername.font = AppFonts.normal
        txtSpecialty.font = AppFonts.normal
        txtEmail.font = AppFonts.normal
        txtPhone.font = AppFonts.normal
        txtBio.font = AppFonts.normal
        txtFacebook.font = AppFonts.normal
        txtTwitter.font = AppFonts.normal
        txtWebsite.font = AppFonts.normal
        txtGithub.font = AppFonts.normal
        txtBehance.font = AppFonts.normal
        
        lblNameTitle.text = "CV_NAME".localized
        lblSpecialtyTitle.text = "CV_SPECIALTY".localized
        lblBioTitle.text = "CV_BIO".localized
        lblContactTitle.text = "CV_CONTACT_INFO".localized
        lblEmailTitle.text = "CV_EMAIL".localized
        lblPhoneTitle.text = "CV_PHONE".localized
        lblCityTitle.text = "FILTER_CITY_TITLE".localized
        btnChangePic.setTitle("CV_CHANGE_IMAGE".localized, for: .normal)
        lblEducationTitle.text = "CV_EDUCATION_TITLE".localized
        lblExperienceTitle.text = "CV_EXPERIENCE_TITLE".localized
        lblSkillsTitle.text = "CV_SKILLS_TITLE".localized
        lblReferenceTitle.text = "CV_REFERENCE_TITLE".localized
        btnAddSkills.setTitle("CV_ADD".localized, for: .normal)
        btnAddEducation.setTitle("CV_ADD".localized, for: .normal)
        btnAddExperience.setTitle("CV_ADD".localized, for: .normal)
        btnSave.setTitle("CV_SAVE".localized, for: .normal)
        btnDone.title = "Done".localized
        
        txtFacebook.placeholder = "example@facebook.com"
        txtTwitter.placeholder =  "example@twiiter.com"
        txtWebsite.placeholder = "example@vibo.com"
        txtGithub.placeholder = "example@github.com"
        txtBehance.placeholder = "example@behance.com"
        
        btnSave.dropShadow()
    }
    
    override func setImage(image: UIImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imgUserPhoto.image = image
        }
    }
}

// MARK:- Functions
extension EditCVViewController {
    func fillUpData(){
        guard let user = DataStore.shared.me else {return}
        
        self.txtUsername.text = user.userName
        self.txtPhone.text = user.mobileNumber

        if let image = user.profilePic {
            self.imgUserPhoto.setImageForURL(image, placeholder: #imageLiteral(resourceName: "user_placeholder"))
            
        }else {
            self.imgUserPhoto.image = #imageLiteral(resourceName: "user_placeholder")
        }
        
        if let cv = user.cv {
            self.selectedCity = cv.city
            self.educations = cv.education ?? []
            self.experiences = cv.experience ?? []
            self.tags = cv.tags ?? []
            self.txtSpecialty.text = cv.primaryIdentifier ?? ""
            self.txtBio.text = cv.bio ?? ""
            //self.t.text = cv.city?.title ?? ""
            
            if let website = cv.websiteLink {
                self.txtWebsite.text = website
            }
            if let facebook = cv.facebookLink {
                self.txtFacebook.text = facebook
            }
            if let behance = cv.behanceLink {
                self.txtBehance.text = behance
            }
            if let github = cv.githubLink {
                self.txtGithub.text = github
            }
            if let twitter = cv.twitterLink {
                self.txtTwitter.text = twitter
            }
            
        }
        
        // reload data
        self.educationTableView.reloadData()
        self.experienceTableView.reloadData()
        self.skillCollectionView.reloadData()
        self.cityCollectionView.reloadData()
    }
    
    func uploadImage(){
        if let image = imgUserPhoto.image{
            ApiManager.shared.uploadImages(images: [image], completionBlock: { (media, error) in
                if error != nil{
                    self.showMessage(message: error!, type: .error)
                }else{
                    if let first = media.first{
                        self.tempCV.profilePic = first.fileUrl
                    }
                }
                self.updateAction()
            })
        }else{
            self.updateAction()
        }
    }

    func updateAction(){
        if let username = txtUsername.text, !username.isEmpty {
            if let phone = txtPhone.text, !phone.isEmpty {
                tempCV.cvURL = DataStore.shared.me?.cv?.cvURL
                tempCV.city = selectedCity
                tempCV.userName = username
                tempCV.email = DataStore.shared.me?.email
                tempCV.phoneNumber = phone
                tempCV.primaryIdentifier = txtSpecialty.text
                tempCV.bio = txtBio.text
                tempCV.experience = experiences
                tempCV.education = educations
                tempCV.tags = tags
                tempCV.behanceLink = txtBehance.text
                tempCV.websiteLink = txtWebsite.text
                tempCV.facebookLink = txtFacebook.text
                tempCV.twitterLink = txtTwitter.text
                tempCV.githubLink = txtGithub.text
                
                self.showActivityLoader(true)
                ApiManager.shared.editCV(cv: tempCV, completionBlock: { (success, error) in
                    
                    if success{
                        ApiManager.shared.getMe(completionBlock: {_,_,_ in
                            self.showActivityLoader(false)
                            self.showMessage(message: "Done".localized, type: .success)
                            self.BackAction(self)
                        })
                        
                    }
                    
                    if error != nil{
                        self.showActivityLoader(false)
                        if let msg = error?.errorName{
                            self.showMessage(message: msg, type: .error)
                        }
                    }
                })
            }else {
                self.showMessage(message: "PHONE_REQEIRED_MSG".localized, type: .error)
            }
        }else {
            self.showMessage(message: "USERNAME_REQEIRED_MSG".localized, type: .error)
        }
        
        
        
    }
}

// MARK:- IBAction
extension EditCVViewController {
    @IBAction func AddExperienceAction(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AddExperienceViewController.className) as! AddExperienceViewController
        vc.mode = .add
        vc.type = .experience
        vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        vc.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func AddEducationAction(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AddExperienceViewController.className) as! AddExperienceViewController
        vc.mode = .add
        vc.type = .education
        vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        vc.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func AddSkillAction(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AddSkillViewController.className) as! AddSkillViewController
        vc.tags = self.tags
        vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        vc.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func EditAction(_ sender: Any) {
        uploadImage()
    }

    @IBAction func SetImageAction(_ sender: UIButton) {
        takePhoto()
    }
    
    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- AddExperienceDelegate
extension EditCVViewController: AddExperienceDelegate {
    func didAddExperience(_ experience: Experience) {
        self.experiences.append(experience)
        self.experienceTableView.reloadData()
        self.experienceTableViewConstant.constant = tableViewRowHeight * CGFloat(experiences.count)
        
        
    }
    
    func didAddEducation(_ education: Education) {
        self.educations.append(education)
        self.educationTableView.reloadData()
        self.educationTableViewConstant.constant = tableViewRowHeight * CGFloat(educations.count)
        
        
    }
    
    func didEditEducation(_ education: Education, index: IndexPath) {
        self.educations[index.row] = education
        self.educationTableView.reloadRows(at: [index], with: .automatic)
        
        
    }
    
    func didEditExperience(_ experience: Experience, index: IndexPath) {
        self.experiences[index.row] = experience
        self.experienceTableView.reloadRows(at: [index], with: .automatic)
        
    
    }
    
    func didDeleteEducation(_ education: Education, index: IndexPath) {
        self.educations.remove(at: index.row)
        self.educationTableView.reloadData()
        self.educationTableViewConstant.constant = tableViewRowHeight * CGFloat(educations.count)
        
        
    }
    
    func didDeleteExperience(_ experience: Experience, index: IndexPath) {
        self.experiences.remove(at: index.row)
        self.experienceTableView.reloadData()
        self.experienceTableViewConstant.constant = tableViewRowHeight * CGFloat(experiences.count)
        
        
    }
}

// MARK:- AddSkillDelegate
extension EditCVViewController: AddSkillDelegate {
    func didAddTags(_ tags: [Tag]) {
        self.tags = tags
        self.skillCollectionView.reloadData()
        self.skillCollectionViewConstant.constant = self.skillCollectionView.contentSize.height
        self.view.layoutIfNeeded()
        
        self.viewWillLayoutSubviews()
    }
}

// MARK:- ExperienceTableViewCellDelegate
extension EditCVViewController: ExperienceTableViewCellDelegate {
    func didTapOnEdit(_ cell: ExperienceTableViewCell) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AddExperienceViewController.className) as! AddExperienceViewController
        vc.mode = .edit
        vc.type = cell.cellType
        vc.delegate = self
        
        if cell.cellType == .education {
            vc.education = self.educations[educationTableView.indexPath(for: cell)!.row]
            vc.index = educationTableView.indexPath(for: cell)!
        }else {
            vc.experience = self.experiences[experienceTableView.indexPath(for: cell)!.row]
            vc.index = experienceTableView.indexPath(for: cell)!
        }
        
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        vc.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK:- UITextViewDelegate
extension EditCVViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
}

// MARK:- UITableViewDelegate
extension EditCVViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.experienceTableView:
            return self.experiences.count
        case self.educationTableView:
            return self.educations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableViewCell", for: indexPath) as! ExperienceTableViewCell
        
        cell.delegate = self
        switch tableView {
        case self.experienceTableView:
            cell.configureForExperience(self.experiences[indexPath.row])
            
            if indexPath.row == self.experiences.count - 1 {
                cell.lineView.isHidden = true
            }else {
                cell.lineView.isHidden = false
            }
            
        case self.educationTableView:
            cell.configureForEducation(self.educations[indexPath.row])
            
        default:
            return cell
        }
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension EditCVViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case skillCollectionView:
            return self.tags.count
        case cityCollectionView:
            return DataStore.shared.cities.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case skillCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
            
            cell.title = self.tags[indexPath.row].name ?? ""
            cell.btnRemove.isHidden = true
            
            cell.layoutIfNeeded()
            
            return cell
        case cityCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
            
            if DataStore.shared.cities[indexPath.row].Fid == self.selectedCity?.Fid {
                cell.isSelected = true
            }else {
                cell.isSelected = false
            }
            
            cell.title = DataStore.shared.cities[indexPath.row].title ?? ""
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.cityCollectionView {
            self.selectedCity = DataStore.shared.cities[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case skillCollectionView:
            let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
        case cityCollectionView:
            let width = DataStore.shared.cities[indexPath.row].title!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
        default:
            return .zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case skillCollectionView:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        case cityCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        default:
            return .zero
        }
    }
}
