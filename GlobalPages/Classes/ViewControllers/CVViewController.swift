//
//  CVViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/21/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class CVViewController: AbstractController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var contactButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var experienceTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var referenceCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var skillsCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var showCVButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var educationTableView: UITableView!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var refrencesCollectionView: UICollectionView!
    
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var imgShowCV: UIImageView!
    @IBOutlet weak var imgExperiencePlaceholder: UIImageView!
    @IBOutlet weak var imgEducationPlaceholder: UIImageView!
    @IBOutlet weak var imgSkillPlaceholder: UIImageView!
    @IBOutlet weak var imgReferencePlaceholder: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblSpecialist: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblExperienceTitle: UILabel!
    @IBOutlet weak var lblRefrenceTitle: UILabel!
    @IBOutlet weak var lblSkillTitle: UILabel!
    @IBOutlet weak var lblEducationTitle: UILabel!
    @IBOutlet weak var lblNoExperiences: UILabel!
    @IBOutlet weak var lblNoSkills: UILabel!
    @IBOutlet weak var lblNoRefrences: UILabel!
    @IBOutlet weak var lblNoEducations: UILabel!

    @IBOutlet weak var btnContact: UIButton!
    
    fileprivate var scrollViewHeight: CGFloat = 0
    fileprivate var currentTopViewConstraint: CGFloat = 0
    fileprivate var currentScrollViewY: CGFloat = 0
    fileprivate var previousOffset: CGFloat = 0
    fileprivate var experiences: [Experience] = []
    fileprivate var educations: [Education] = []
    fileprivate var tags: [Tag] = []
    fileprivate var refrences: [Refrence] = []
    fileprivate var didInitilize: Bool = false
    
    public var user: AppUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func buildUp() {
        setupListViews()
        fillUserData()
        
        btnContact.isHidden = true
        scrollView.delegate = self
        
        // change the tags collection view height on tags count
        if self.tags.count > 2 {
            self.skillsCollectionViewConstraint.constant = 100
        }else {
            self.skillsCollectionViewConstraint.constant = 50
        }
        
        // reduce the view height when there is no uploaded cv
        if let _ = user?.cv?.cvURL {
            self.showCVButtonConstraint.constant = 256
        }else {
            self.showCVButtonConstraint.constant = 0
        }
        
        // Check if the data is empty to put the placeholder instead
        if educations.count == 0 {
            self.educationTableView.isHidden = true
        }
        if tags.count == 0 {
            self.skillsCollectionView.isHidden = true
        }
        if experiences.count == 0 {
            self.experienceTableView.isHidden = true
        }
        if refrences.count == 0 {
            self.refrencesCollectionView.isHidden = true
        }
        
        // setup show CV tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowCVAction(_:)))
        imgShowCV.addGestureRecognizer(tap)
    }
    
    override func customizeView() {
        lblUsername.font = AppFonts.xBigBold
        lblSpecialist.font = AppFonts.normalSemiBold
        lblLocation.font = AppFonts.normal
        lblBio.font = AppFonts.normal
        lblExperienceTitle.font = AppFonts.bigSemiBold
        lblEducationTitle.font = AppFonts.bigSemiBold
        lblSkillTitle.font = AppFonts.bigSemiBold
        lblRefrenceTitle.font = AppFonts.bigSemiBold
        btnContact.titleLabel?.font = AppFonts.big
        
        
        lblRefrenceTitle.text = "CV_REFERENCE_TITLE".localized
        lblEducationTitle.text = "CV_EDUCATION_TITLE".localized
        lblExperienceTitle.text = "CV_EXPERIENCE_TITLE".localized
        lblSkillTitle.text = "CV_SKILLS_TITLE".localized
        
        lblNoExperiences.text = "CV_EXPERIENCE_PLACEHOLDER".localized
        lblNoRefrences.text = "CV_REFERENCE_PLACEHOLDER".localized
        lblNoSkills.text = "CV_SKILLS_PLACEHOLDER".localized
        lblNoEducations.text = "CV_EDUCATION_PLACEHOLDER".localized
    }

    override func viewWillLayoutSubviews() {
        // To expend all tableView data without scrolling from inside
        self.experienceTableViewConstraint.constant = self.experienceTableView.contentSize.height
        self.educationTableViewConstraint.constant = self.educationTableView.contentSize.height
        self.skillsCollectionViewConstraint.constant = self.skillsCollectionView.contentSize.height
//        self.referenceCollectionViewConstraint.constant = self.refrencesCollectionView.contentSize.height
        
        // Check for placeholders
        if educations.count == 0 {
            self.educationTableViewConstraint.constant = 100
            self.lblNoEducations.isHidden = false
            self.imgEducationPlaceholder.isHidden = false
        }else {
            self.lblNoEducations.isHidden = true
            self.imgEducationPlaceholder.isHidden = true
        }
        
        if experiences.count == 0 {
            self.experienceTableViewConstraint.constant = 100
            self.lblNoExperiences.isHidden = false
            self.imgExperiencePlaceholder.isHidden = false
        }else {
            self.lblNoExperiences.isHidden = true
            self.imgExperiencePlaceholder.isHidden = true
        }
        
        if tags.count == 0 {
            self.skillsCollectionViewConstraint.constant = 100
            self.lblNoSkills.isHidden = false
            self.imgSkillPlaceholder.isHidden = false
        }else {
            self.lblNoSkills.isHidden = true
            self.imgSkillPlaceholder.isHidden = true
        }
        
        if refrences.count == 0 {
            self.referenceCollectionViewConstraint.constant = 100
            self.lblNoRefrences.isHidden = false
            self.imgReferencePlaceholder.isHidden = false
        }else {
            self.referenceCollectionViewConstraint.constant = 75
            self.lblNoRefrences.isHidden = true
            self.imgReferencePlaceholder.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.currentTopViewConstraint = self.topView.frame.height
        self.currentScrollViewY = self.scrollView.frame.origin.y
        self.scrollViewHeight = scrollView.frame.size.height
        self.didInitilize = true
    }
}

// MARK:- Functions
extension CVViewController {
    func setupListViews(){
        self.experienceTableView.delegate = self
        self.experienceTableView.dataSource = self
        self.educationTableView.delegate = self
        self.educationTableView.dataSource = self
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
        self.refrencesCollectionView.delegate = self
        self.refrencesCollectionView.dataSource = self
        
        self.experienceTableView.rowHeight = 72
        self.educationTableView.rowHeight = 72
        
        self.experienceTableView.isScrollEnabled = false
        self.educationTableView.isScrollEnabled = false
        self.skillsCollectionView.isScrollEnabled = false
        
        self.experienceTableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        self.educationTableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        
        self.skillsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: AppConfig.currentLanguage == .arabic ? .right : .left, verticalAlignment: .top)
        
        self.scrollView.alwaysBounceVertical = true
        
        
    }
    
    func fillUserData(){
        guard let user = user else {return}
        
        self.lblUsername.text = user.userName
        
        if let image = user.profilePic {
            self.imgUserPhoto.setImageForURL(image, placeholder: #imageLiteral(resourceName: "user_placeholder"))
            
        }else {
            self.imgUserPhoto.image = #imageLiteral(resourceName: "user_placeholder")
        }
        
        self.educations = user.cv?.education ?? []
        self.experiences = user.cv?.experience ?? []
        self.tags = user.cv?.tags ?? []
        self.lblSpecialist.text = user.cv?.primaryIdentifier ?? "CV_SPECIALIZATION_PLACEHOLDER".localized
        self.lblBio.text = user.cv?.bio ?? ""
        self.lblLocation.text = user.cv?.city?.title ?? "CV_LOCATION_PLACEHOLDER".localized
        
        if let website = user.cv?.websiteLink, website != "" {
            self.refrences.append(Refrence(url: website, type: .website))
        }
        if let facebook = user.cv?.facebookLink , facebook != ""{
            self.refrences.append(Refrence(url: facebook, type: .facebook))
        }
        if let behance = user.cv?.behanceLink , behance != ""{
            self.refrences.append(Refrence(url: behance, type: .behance))
        }
        if let github = user.cv?.githubLink , github != ""{
            self.refrences.append(Refrence(url: github, type: .github))
        }
        if let twitter = user.cv?.twitterLink , twitter != ""{
            self.refrences.append(Refrence(url: twitter, type: .twitter))
        }
        
        
        // reload data
        self.educationTableView.reloadData()
        self.experienceTableView.reloadData()
        self.skillsCollectionView.reloadData()
        self.refrencesCollectionView.reloadData()
        
        self.contentView.layoutIfNeeded()
        viewWillLayoutSubviews()
    }
}

// MARK:- IBAction
extension CVViewController {
    @IBAction func DismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func ShowCVAction(_ sender: Any) {
        guard let url = URL(string: user?.cv?.cvURL ?? "") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}

// MARK:- UIScrollViewDelegate
extension CVViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollViewHeight = scrollView.frame.size.height
//        let scrollContentSizeHeight = scrollView.contentSize.height
//        let offset = scrollView.contentOffset.y
//
//        if !((offset + scrollViewHeight) >= scrollContentSizeHeight) {
//            UIView.animate(withDuration: 0.25, animations: {[weak self] in
//
//
//                var newHeight_topView = (self?.currentTopViewConstraint)! - offset
//
//                if newHeight_topView > self!.currentTopViewConstraint {
//                    newHeight_topView = self!.currentTopViewConstraint
//                    self?.btnContact.alpha = 1
//
//                }else if newHeight_topView < 0 {
//                    newHeight_topView = 0
//                }
//
//                self?.btnContact.alpha = 0.1 * (newHeight_topView / 10)
//                self?.topViewConstraint.constant = newHeight_topView
//
//                }, completion: nil)
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if didInitilize {
            UIView.animate(withDuration: 0.5, animations: {[weak self] in
            let offset = scrollView.contentOffset.y
            
            //var newHeight_topView = (self?.currentTopViewConstraint)! - offset
            var newY_scrollView = (self?.scrollView.frame.origin.y)! - (offset / 0.1)
            var newHeight = self!.scrollViewHeight + offset
            
            if newY_scrollView <= 20 {
                newY_scrollView = 20
                newHeight = (self!.scrollViewHeight + self!.currentTopViewConstraint) - 20
            }
            
            if newY_scrollView > self!.currentScrollViewY {
                newY_scrollView = self!.currentScrollViewY
                newHeight = self!.scrollViewHeight
            }
            
            self?.scrollView.frame.origin.y = newY_scrollView
            self?.scrollView.frame.size = CGSize(width: (self?.view.frame.width)!, height: newHeight)
            
            }, completion: nil)
        }
        
    }

}

// MARK:- UITableViewDelegate
extension CVViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        cell.btnEdit.isHidden = true
        
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
extension CVViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.refrencesCollectionView:
            return self.refrences.count
        case self.skillsCollectionView:
            return self.tags.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.refrencesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "refrenceCollectionViewCell", for: indexPath)
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = self.refrences[indexPath.row].type?.icon
        
            return cell
            
        case self.skillsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
            
            cell.title = self.tags[indexPath.row].name ?? ""
            cell.btnRemove.isHidden = true
            
            cell.layoutIfNeeded()
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.refrencesCollectionView:
            guard let url = URL(string: self.refrences[indexPath.row].url ?? "") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        default:
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case self.refrencesCollectionView:
            return CGSize(width: 50, height: 50)
            
        case self.skillsCollectionView:
            let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView {
        case self.refrencesCollectionView:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
        case self.skillsCollectionView:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        default:
            return .zero
        }
        
    }
}
