//
//  JobDescriptionViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/30/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class JobDescriptionViewController: AbstractController {

    @IBOutlet weak var lblPoition: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    //@IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblResponsipiltiesTitle: UILabel!
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var lblSkillsTitle: UILabel!
    @IBOutlet weak var lblQualificationTitle: UILabel!
    @IBOutlet weak var lblSalaryRangeTitle: UILabel!
    @IBOutlet weak var lblJobTimeTitle: UILabel!
    @IBOutlet weak var lblEducationLevelTitle: UILabel!
    @IBOutlet weak var lblResponsipilties: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblQualification: UILabel!
    @IBOutlet weak var lblSalaryRange: UILabel!
    @IBOutlet weak var lblJobTime: UILabel!
    @IBOutlet weak var lblEducationLevel: UILabel!
    @IBOutlet weak var lblApplied: UILabel!
    
    @IBOutlet weak var btnApply1: XUIButton!
    @IBOutlet weak var btnApply2: XUIButton!
    @IBOutlet weak var btnEditJob: UIBarButtonItem!
    //@IBOutlet weak var btnApplicants: UIBarButtonItem!
    @IBOutlet weak var btnDeactiveJob: UIButton!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var skillsCollectionViewConstant: NSLayoutConstraint!
    @IBOutlet weak var responsipiltiesConstant: NSLayoutConstraint!
    @IBOutlet weak var skillsConstant: NSLayoutConstraint!
    @IBOutlet weak var salaryRangeConstant: NSLayoutConstraint!
    @IBOutlet weak var descriptionConstant: NSLayoutConstraint!
    @IBOutlet weak var jobTimeConstant: NSLayoutConstraint!
    @IBOutlet weak var qualificationConstant: NSLayoutConstraint!
    @IBOutlet weak var educationLevelConstant: NSLayoutConstraint!
    
    fileprivate var tags: [Tag] = []
    fileprivate var fieldConstantHeight: CGFloat = 50
    fileprivate var lblBadge: UILabel!
    
    public var jobId: String = ""
    public var job: Job?
    public var showBudget: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        fillUpData()
        getJob()
        
        
        // Setup skills collection view
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        self.skillsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: AppConfig.currentLanguage == .arabic ? .right : .left, verticalAlignment: .top)
    }

    override func buildUp() {
    }
    
    override func customizeView() {
        lblPoition.font = AppFonts.xBigBold
        lblCompanyName.font = AppFonts.normalSemiBold
        lblAddress.font = AppFonts.normal
        lblCategory.font = AppFonts.normal
        lblSubCategory.font = AppFonts.normal
        //lblBudget.font = AppFonts.small
        lblDate.font = AppFonts.small
        lblResponsipiltiesTitle.font = AppFonts.bigBold
        lblDescriptionTitle.font = AppFonts.bigBold
        lblSkillsTitle.font = AppFonts.bigBold
        lblSalaryRangeTitle.font = AppFonts.bigBold
        lblJobTimeTitle.font = AppFonts.bigBold
        lblQualificationTitle.font = AppFonts.bigBold
        lblEducationLevelTitle.font = AppFonts.bigBold
        lblResponsipilties.font = AppFonts.normal
        lblDescription.font = AppFonts.normal
        lblQualification.font = AppFonts.normal
        lblJobTime.font = AppFonts.normal
        lblSalaryRange.font = AppFonts.normal
        lblEducationLevel.font = AppFonts.normal
        lblApplied.font = AppFonts.normalSemiBold
        
        btnApply1.titleLabel?.font = AppFonts.smallSemiBold
        btnDeactiveJob.titleLabel?.font = AppFonts.smallSemiBold
        btnApply2.titleLabel?.font = AppFonts.bigSemiBold
        
        btnApply1.dropShadow()
        btnApply2.dropShadow()
        
        lblResponsipiltiesTitle.text = "JOB_RESPONSIPILITIES".localized
        lblDescriptionTitle.text = "JOB_DESCRIPTION".localized
        lblSkillsTitle.text = "JOB_SKILLS".localized
        lblQualificationTitle.text = "JOB_QUALIFICATION".localized
        lblSalaryRangeTitle.text = "JOB_SALARY_RANGE".localized
        lblJobTimeTitle.text = "JOB_TYPE_TITLE".localized
        lblEducationLevelTitle.text = "JOB_EDUCATION_LEVEL".localized
        btnDeactiveJob.setTitle("JOB_DEACTIVE".localized, for: .normal)
        btnApply1.setTitle("APPLY".localized, for: .normal)
        btnApply2.setTitle("APPLY".localized, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        self.skillsCollectionViewConstant.constant = self.skillsCollectionView.contentSize.height
    }
    
    func fillUpData(){
        lblPoition.text = job?.name
        lblCompanyName.text = job?.business?.title
        lblAddress.text = "\(job?.business?.city?.title ?? "") | \(job?.business?.location?.title ?? "")"
        lblDate.text = DateHelper.convertDateStringToCustomFormat(job?.creationDate ?? "", format: "dd, MMM yyyy")
        //lblBudget.isHidden = !showBudget
        lblCategory.text = job?.category?.title
        lblSubCategory.text = job?.subCategory?.title
        lblBadge.text = String(job?.numberOfApplicants ?? 0)
        
        if let url = job?.business?.logo, url != "" {
            imgLogo.setImageForURL(url, placeholder: #imageLiteral(resourceName: "business_placeholder"))
        }else {
            imgLogo.image = #imageLiteral(resourceName: "business_placeholder")
        }
        
        if let responsipilties = job?.responsibilitiesTitle, responsipilties != "" {
            lblResponsipilties.text = responsipilties
            responsipiltiesConstant.constant = fieldConstantHeight
            lblResponsipiltiesTitle.isHidden = false
        }else {
            responsipiltiesConstant.constant = 0
            lblResponsipiltiesTitle.isHidden = true
        }
        
        if let qualifications = job?.qualificationsTitle, qualifications != "" {
            lblQualification.text = qualifications
            qualificationConstant.constant = fieldConstantHeight
            lblQualificationTitle.isHidden = false
        }else {
            qualificationConstant.constant = 0
            lblQualificationTitle.isHidden = true
        }
        
        if let description = job?.description, description != "" {
            lblDescription.text = description
            descriptionConstant.constant = fieldConstantHeight
            lblDescriptionTitle.isHidden = false
        }else {
            descriptionConstant.constant = 0
            lblDescriptionTitle.isHidden = true
        }
        
        if let skills = job?.tags, skills.count != 0 {
            tags = skills
            skillsCollectionView.reloadData()
            //skillsCollectionViewConstant.constant = skillsCollectionView.contentSize.height
            self.contentView.layoutIfNeeded()
            self.viewWillLayoutSubviews()
            skillsConstant.constant = fieldConstantHeight
            lblSkillsTitle.isHidden = false
        }else {
            skillsConstant.constant = 0
            lblSkillsTitle.isHidden = true
        }
        
        if let salaryRange = job?.rangeSalary, salaryRange != "" {
            lblSalaryRange.text = salaryRange
            salaryRangeConstant.constant = fieldConstantHeight
            lblSkillsTitle.isHidden = false
        }else {
            salaryRangeConstant.constant = 0
            lblSkillsTitle.isHidden = true
        }
        
        if let educationLevel = job?.educationLevel, educationLevel != "" {
            lblEducationLevel.text = EducationLevel(rawValue: educationLevel)?.title
            educationLevelConstant.constant = fieldConstantHeight
            lblEducationLevelTitle.isHidden = false
        }else {
            educationLevelConstant.constant = 0
            lblEducationLevelTitle.isHidden = true
        }
        
        if let jobType = job?.jobType, jobType != "" {
            lblJobTime.text = JobType(rawValue: jobType)?.title
            jobTimeConstant.constant = fieldConstantHeight
            lblJobTimeTitle.isHidden = false
        }else {
            jobTimeConstant.constant = 0
            lblJobTimeTitle.isHidden = true
        }
        
        self.btnApply1.isHidden = job?.isApplied ?? false
        self.btnApply2.isHidden = job?.isApplied ?? false
        self.lblApplied.isHidden = !(job?.isApplied ?? false)
        
        if self.job?.ownerId == DataStore.shared.me?.objectId {
            self.lblApplied.isHidden = true
            self.btnDeactiveJob.isHidden = false
            self.btnApply1.isHidden = true
            self.btnApply2.isHidden = true
        }else {
            self.btnDeactiveJob.isHidden = true
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    func getJob(){
        ApiManager.shared.getJobById(id: job?.jobId ?? jobId, completionBlock: {success, error, result in
            if let error = error {
                self.showMessage(message: error.type.errorMessage, type: .error)
                return
            }
            
            if let job = result {
                self.job = job
                self.fillUpData()
            }
        })
    }
    
    func setupNavigationBar() {
        let btnApplicants = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btnApplicants.setImage(#imageLiteral(resourceName: "employee"), for: .normal)
        btnApplicants.addTarget(self, action: #selector(self.ApplicantsAction(_:)), for: .touchUpInside)
        
        lblBadge = UILabel(frame: CGRect(x: -12, y: 0, width: 16, height: 16))
        lblBadge.backgroundColor = .red
        lblBadge.textColor = .white
        lblBadge.textAlignment = .center
        lblBadge.layer.cornerRadius = 8
        lblBadge.layer.masksToBounds = true
        lblBadge.text = "20"
        lblBadge.font = AppFonts.xSmall

        btnApplicants.addSubview(lblBadge)
        
        self.navigationItem.rightBarButtonItems = [btnEditJob, UIBarButtonItem(customView: btnApplicants)]
    }

}

// MARK:- @IBAction
extension JobDescriptionViewController {
    @IBAction func ApplyAction(_ sender: Any){
        if DataStore.shared.isLoggedin {
            if DataStore.shared.me?.objectId != self.job?.ownerId {
                let alert = UIAlertController(title: "APPLY_CONFIRMATION".localized, message: "APPLY_CONFIRMATION_MSG".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "APPLY".localized, style: .default, handler: {_ in
                    self.showActivityLoader(true)
                    ApiManager.shared.applyForJob(id: self.job?.jobId ?? "", completionBlock: {success, error in
                        self.showActivityLoader(false)
                        if let error = error {
                            self.showMessage(message: error.type.errorMessage, type: .error)
                            return
                        }
                        
                        if success {
                            self.showMessage(message: "APPLIED_MSG".localized, type: .success)
                            self.getJob()
                        }
                    })
                }))
                
                alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }else {
                self.showMessage(message: "JOB_OWNER_MSG".localized, type: .warning)
            }
        }else {
            self.showMessage(message: "LOGIN_FIRST_MSG".localized, type: .warning)
        }
        
        
    }
    
    @IBAction func BackAction(_ sender: Any){
        self.backButtonAction(self)
    }
    
    @IBAction func DeactiveJobAction(_ sender: Any){
        let deactiveAlert = UIAlertController(title: "GLOBAL_WARNING_TITLE".localized, message: "JOB_DEACTIVE_WARNING".localized, preferredStyle: .alert)
        deactiveAlert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        deactiveAlert.addAction(UIAlertAction(title: "JOB_DEACTIVE".localized, style: .destructive, handler: {_ in
            self.showActivityLoader(true)
            ApiManager.shared.deactiveJob(id: self.job?.jobId ?? "", completionBlock: {success, error in
                self.showActivityLoader(false)
                if let error = error {
                    self.showMessage(message: error.type.errorMessage , type: .error )
                    return
                }
                
                self.btnDeactiveJob.isHidden = true
            })
        }))
        self.present(deactiveAlert, animated: true, completion: nil)
    }
    
    @IBAction func EditJobAction(_ sender: Any){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AddEditJobViewController.className)  as! AddEditJobViewController
        
        vc.mode = .edit
        vc.businessId = self.job?.businessId
        vc.job = self.job
        vc.modalPresentationStyle = .fullScreen
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func ApplicantsAction(_ sender: Any){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: ApplicantsViewController.className)  as! ApplicantsViewController
        
        vc.job = self.job
        vc.modalPresentationStyle = .fullScreen
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDelegate
extension JobDescriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
        
        cell.title = self.tags[indexPath.row].name ?? ""
        cell.btnRemove.isHidden = true
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 32
        
        return CGSize(width: width, height: 30)
    }
    
}
