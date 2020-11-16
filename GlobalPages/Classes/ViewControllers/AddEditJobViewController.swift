//
//  AddEditJobViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 11/3/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit
import Firebase

class AddEditJobViewController: AbstractController {

    // MARK:- Base Info Section
    @IBOutlet weak var txtNameEn: UITextField!
    @IBOutlet weak var txtNameAr: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtSubCategory: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    @IBOutlet weak var txtEducationLevel: UITextField!
    @IBOutlet weak var txtJobType: UITextField!
    @IBOutlet weak var bussinessCollectionView: UICollectionView!
    
    @IBOutlet weak var lblBaseInfoTitle: UILabel!
    @IBOutlet weak var lblNameEnTitle: UILabel!
    @IBOutlet weak var lblNameArTitle: UILabel!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblSubCategoryTitle: UILabel!
    @IBOutlet weak var lblSalaryTitle: UILabel!
    @IBOutlet weak var lblEducationLevelTitle: UILabel!
    @IBOutlet weak var lblJobTypeTitle: UILabel!
    @IBOutlet weak var lblBussinessTitle: UILabel!
    
    // MARK:- Job Description Section
    @IBOutlet weak var lblJobDetailsTitle: UILabel!
    @IBOutlet weak var lblResponsipiltiesArTitle: UILabel!
    @IBOutlet weak var lblDescriptionArTitle: UILabel!
    @IBOutlet weak var lblQualificationArTitle: UILabel!
    @IBOutlet weak var lblResponsipiltiesEnTitle: UILabel!
    @IBOutlet weak var lblDescriptionEnTitle: UILabel!
    @IBOutlet weak var lblQualificationEnTitle: UILabel!
    
    @IBOutlet weak var txtResponsipiltiesAr: UITextView!
    @IBOutlet weak var txtDescriptionAr: UITextView!
    @IBOutlet weak var txtQualificationAr: UITextView!
    @IBOutlet weak var txtResponsipiltiesEn: UITextView!
    @IBOutlet weak var txtDescriptionEn: UITextView!
    @IBOutlet weak var txtQualificationEn: UITextView!

    // MARK:- Skills Section
    @IBOutlet weak var lblSkillsTitle: UILabel!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var skillsCollectionViewConstant: NSLayoutConstraint!
    @IBOutlet weak var btnAddSkill: UIButton!
    
    // MARK:- General Section
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    public var mode: Mode = .add
    public var job: Job?
    public var businessId: String?
    
    fileprivate var bussiness: [Bussiness] = []
    fileprivate var tags: [Tag] = []
    fileprivate var fixedWidth: CGFloat = CGFloat()
    fileprivate var dataPicker: UIPickerView!
    fileprivate var categories: [Category] = []
    fileprivate var subcategories: [Category] = []
    fileprivate var educationLevel: [String] = []
    fileprivate var jobTypes: [String] = []
    fileprivate var selectedCategory: Category?
    fileprivate var selectedSubCategory: Category?
    fileprivate var selectedEducationLevel: String?
    fileprivate var selectedJobType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("add_job_opened", parameters: [:])
        // Do any additional setup after loading the view.
    }
    
    override func buildUp() {
        // Setup skills collection view
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        self.skillsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: AppConfig.currentLanguage == .arabic ? .right : .left, verticalAlignment: .top)
        
        // Setup bussiness collection view
        self.bussinessCollectionView.delegate = self
        self.bussinessCollectionView.dataSource = self
        self.bussinessCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        
        if self.mode == .edit {
            self.fillUpData()
            self.title = "JOB_EDIT_TITLE".localized
        }else {
            self.title = "JOB_ADD_TITLE".localized
        }
        
        educationLevel = EducationLevel.allCases.map { $0.rawValue }
        jobTypes = JobType.allCases.map { $0.rawValue }
        educationLevel.insert("", at: 0)
        jobTypes.insert("", at: 0)
        
        txtCategory.isEnabled = false
        txtSubCategory.isEnabled = false
        
        getCategories()
        
        getBussiness()
        
        setupDataPicker()
    }
    
    override func customizeView() {
        lblBaseInfoTitle.font = AppFonts.bigBold
        lblNameEnTitle.font = AppFonts.normalBold
        lblNameArTitle.font = AppFonts.normalBold
        lblCategoryTitle.font = AppFonts.normalBold
        lblSubCategoryTitle.font = AppFonts.normalBold
        lblSalaryTitle.font = AppFonts.normalBold
        lblEducationLevelTitle.font = AppFonts.normalBold
        lblJobTypeTitle.font = AppFonts.normalBold
        lblBussinessTitle.font = AppFonts.normalBold
        lblJobDetailsTitle.font = AppFonts.bigBold
        lblResponsipiltiesArTitle.font = AppFonts.normalBold
        lblDescriptionArTitle.font = AppFonts.normalBold
        lblQualificationArTitle.font = AppFonts.normalBold
        lblResponsipiltiesEnTitle.font = AppFonts.normalBold
        lblDescriptionEnTitle.font = AppFonts.normalBold
        lblQualificationEnTitle.font = AppFonts.normalBold
        lblSkillsTitle.font = AppFonts.bigBold
        
        txtResponsipiltiesAr.font = AppFonts.normal
        txtDescriptionAr.font = AppFonts.normal
        txtQualificationAr.font = AppFonts.normal
        txtResponsipiltiesEn.font = AppFonts.normal
        txtDescriptionEn.font = AppFonts.normal
        txtQualificationEn.font = AppFonts.normal
        txtNameAr.font = AppFonts.normal
        txtNameEn.font = AppFonts.normal
        txtCategory.font = AppFonts.normal
        txtSubCategory.font = AppFonts.normal
        txtSalary.font = AppFonts.normal
        txtEducationLevel.font = AppFonts.normal
        txtJobType.font = AppFonts.normal
        
        btnAddSkill.titleLabel?.font = AppFonts.normalBold

        lblBaseInfoTitle.text = "JOB_BASE_INFO_TITLE".localized
        lblNameEnTitle.text = "JOB_NAME_EN".localized
        lblNameArTitle.text = "JOB_NAME_AR".localized
        lblCategoryTitle.text = "JOB_CATEGORY".localized
        lblSubCategoryTitle.text = "JOB_SUBCATEGORY".localized
        lblSalaryTitle.text = "JOB_SALARY".localized
        lblEducationLevelTitle.text = "JOB_EDUCATION_LEVEL".localized
        lblJobTypeTitle.text = "JOB_TYPE_TITLE".localized
        lblBussinessTitle.text = "JOB_BUSSINESS_TITLE".localized
        
        lblJobDetailsTitle.text = "JOB_DESCRIPTION".localized
        lblResponsipiltiesArTitle.text = "JOB_RESPONSIPILITIES_AR".localized
        lblDescriptionArTitle.text = "JOB_DESCRIPTION_AR".localized
        lblQualificationArTitle.text = "JOB_QUALIFICATION_AR".localized
        lblResponsipiltiesEnTitle.text = "JOB_RESPONSIPILITIES_EN".localized
        lblDescriptionEnTitle.text = "JOB_DESCRIPTION_EN".localized
        lblQualificationEnTitle.text = "JOB_QUALIFICATION_EN".localized
        lblSkillsTitle.text = "JOB_SKILLS".localized
        
        btnAddSkill.setTitle("ADD_BUTTON_TITLE".localized, for: .normal)
        
        btnDone.title = "Done".localized
    }
    
    override func viewWillLayoutSubviews() {
        self.skillsCollectionViewConstant.constant = self.skillsCollectionView.contentSize.height
        self.fixedWidth = (self.view.frame.width * 0.65)
        
        // Setup dynamic height for UITextView
        setupTextViews([txtDescriptionAr, txtDescriptionEn, txtResponsipiltiesAr, txtResponsipiltiesEn, txtQualificationAr, txtQualificationEn])
    }

    func fillUpData() {
        tags = self.job?.tags ?? []
        
        txtNameAr.text = job?.nameAr ?? ""
        txtNameEn.text = job?.nameEn ?? ""
        txtCategory.text = job?.category?.title ?? ""
        txtSubCategory.text = job?.subCategory?.title ?? ""
        txtSalary.text = job?.rangeSalary ?? ""
        txtEducationLevel.text = EducationLevel(rawValue: job?.educationLevel ?? "")?.title
        txtJobType.text = JobType(rawValue: job?.jobType ?? "")?.title
        txtDescriptionAr.text = job?.descriptionAr ?? ""
        txtDescriptionEn.text = job?.descriptionEn ?? ""
        txtResponsipiltiesEn.text = job?.responsibilitiesEn ?? ""
        txtResponsipiltiesAr.text = job?.responsibilitiesAr ?? ""
        txtQualificationEn.text = job?.qualificationsEn ?? ""
        txtQualificationAr.text = job?.qualificationsAr ?? ""
        
        selectedCategory = job?.category
        selectedSubCategory = job?.subCategory
        selectedJobType = job?.jobType
        selectedEducationLevel = job?.educationLevel
        
        skillsCollectionView.reloadData()
        self.contentView.layoutIfNeeded()
    }
    
    func setupTextViews(_ fields: [UITextView]) {
        for field in fields {
            let newSize = field.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            field.translatesAutoresizingMaskIntoConstraints = true
            field.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            field.isScrollEnabled = false
            field.delegate = self
        }
    }
    
    func setupDataPicker(){
        dataPicker = UIPickerView()
        dataPicker.delegate = self
        dataPicker.dataSource = self
        
        txtEducationLevel.inputView = dataPicker
        txtJobType.inputView = dataPicker
        txtCategory.inputView = dataPicker
        txtSubCategory.inputView = dataPicker
        
        txtJobType.delegate = self
        txtEducationLevel.delegate = self
        txtCategory.delegate = self
        txtSubCategory.delegate = self
    }
    
    func getCategories() {
        self.showActivityLoader(true)
        
        ApiManager.shared.jobCategories { (success, error, result,cats) in
            self.showActivityLoader(false)
            if success{
                self.categories = cats.filter({$0.parentCategoryId == nil})
                self.txtCategory.isEnabled = true
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

    }
    
    func getBussiness(){
        guard let ownerId = DataStore.shared.me?.objectId else { return }
        self.showActivityLoader(true)
        ApiManager.shared.getUserBussiness(ownerId: ownerId) { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                self.bussiness = result
                
                self.bussinessCollectionView.reloadData()
                
            }
            if error != nil{}
        }
    }
}

// MARK:- UIPickerViewDelegate
extension AddEditJobViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return categories.count + 1
        case 2:
            return subcategories.count + 1
        case 3:
            return educationLevel.count
        case 4:
            return jobTypes.count
        default:
            return 0
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return row == 0 ? "" : categories[row - 1].title
        case 2:
            return row == 0 ? "" : subcategories[row - 1].title
        case 3:
            return EducationLevel(rawValue: educationLevel[row])?.title
        case 4:
            return JobType(rawValue: jobTypes[row])?.title
        default:
            return nil
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtCategory.text = row == 0 ? "" : categories[row - 1].title
            if row != 0 {
                txtSubCategory.text = ""
                subcategories = categories[row - 1].subCategories ?? []
                txtSubCategory.isEnabled = true
                selectedCategory = categories[row - 1]
            }else {
                txtSubCategory.text = ""
                txtSubCategory.isEnabled = false
                selectedCategory = nil
            }
        case 2:
            txtSubCategory.text = row == 0 ? "" : subcategories[row - 1].title
            if row != 0 {
                
                selectedSubCategory = subcategories[row - 1]
            }else {
                selectedSubCategory = nil
            }
        case 3:
            selectedEducationLevel = educationLevel[row]
            txtEducationLevel.text = row == 0 ? "" : EducationLevel(rawValue: educationLevel[row])?.title
        case 4:
            selectedJobType = jobTypes[row]
            txtJobType.text = row == 0 ? "" : JobType(rawValue: jobTypes[row])?.title
        default:
            return
        }

    }
    
}

// MARK:- IBAction
extension AddEditJobViewController {
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
    
    @IBAction func DismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddJobAction(_ sender: Any) {
        if !(txtNameAr.text!.isEmpty)  || !(txtNameEn.text!.isEmpty) {
            if let category = self.selectedCategory {
                if let subCategory = self.selectedSubCategory {
                    if let bussinessId = self.businessId {
                        if mode == .add {
                            job = Job()
                            job?.nameAr = txtNameAr.text
                            job?.nameEn = txtNameEn.text
                            job?.category = category
                            job?.subCategory = subCategory
                            job?.rangeSalary = txtSalary.text
                            job?.educationLevel = selectedEducationLevel
                            job?.jobType = selectedJobType
                            job?.descriptionAr = txtDescriptionAr.text
                            job?.descriptionEn = txtDescriptionEn.text
                            job?.responsibilitiesAr = txtResponsipiltiesAr.text
                            job?.responsibilitiesEn = txtResponsipiltiesEn.text
                            job?.qualificationsAr = txtQualificationAr.text
                            job?.qualificationsEn = txtQualificationEn.text
                            job?.tags = self.tags
                            
                            self.showActivityLoader(true)
                            ApiManager.shared.addJob(id: bussinessId, job: self.job!, completionBlock: { success, error in
                                self.showActivityLoader(false)
                                
                                if let error = error {
                                    self.showMessage(message: error.type.errorMessage, type: .error)
                                    return
                                }else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                            
                        }else {
                            job?.nameAr = txtNameAr.text
                            job?.nameEn = txtNameEn.text
                            job?.category = category
                            job?.subCategory = subCategory
                            job?.rangeSalary = txtSalary.text
                            job?.educationLevel = selectedEducationLevel
                            job?.jobType = selectedJobType
                            job?.descriptionAr = txtDescriptionAr.text
                            job?.descriptionEn = txtDescriptionEn.text
                            job?.responsibilitiesAr = txtResponsipiltiesAr.text
                            job?.responsibilitiesEn = txtResponsipiltiesEn.text
                            job?.qualificationsAr = txtQualificationAr.text
                            job?.qualificationsEn = txtQualificationEn.text
                            job?.tags = self.tags
                            
                            self.showActivityLoader(true)
                            ApiManager.shared.updateJob(job: self.job!, completionBlock: { success, error in
                                self.showActivityLoader(false)
                                
                                if let error = error {
                                    self.showMessage(message: error.type.errorMessage, type: .error)
                                    return
                                }else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }

                    }else {
                        self.showMessage(message: "JOB_BUSSINESS_REQUEIRED".localized, type: .error)
                    }
                                        
                }else {
                    self.showMessage(message: "JOB_SUBCATEGORY_REQUEIRED".localized, type: .error)
                }
            }else {
                self.showMessage(message: "JOB_CATEGORY_REQUEIRED".localized, type: .error)
            }
        }else {
            self.showMessage(message: "JOB_NAME_REQUEIRED".localized, type: .error)
        }
    }
}

// MARK:- UICollectionViewDelegate
extension AddEditJobViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.skillsCollectionView {
            return self.tags.count
        }
        
        if collectionView == self.bussinessCollectionView {
            return self.bussiness.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
            
            cell.title = self.tags[indexPath.row].name ?? ""
            cell.btnRemove.isHidden = true
            
            cell.layoutIfNeeded()
            
            return cell
        }
        
        if collectionView == self.bussinessCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
            
            
            cell.title = self.bussiness[indexPath.row].title ?? ""
            cell.btnRemove.isHidden = true
            
            if self.businessId == self.bussiness[indexPath.row].id {
                cell.isSelect = true
            }else {
                cell.isSelect = false
            }
            
            //cell.layoutIfNeeded()
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.bussinessCollectionView {
            self.businessId = self.bussiness[indexPath.row].id
            self.bussinessCollectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.skillsCollectionView {
            let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
        }
        
        if collectionView == self.bussinessCollectionView {
            let width = self.bussiness[indexPath.row].title!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
        }
        
        return .zero
    }
    
}

// MARK:- AddSkillDelegate
extension AddEditJobViewController: AddSkillDelegate {
    func didAddTags(_ tags: [Tag]) {
        self.tags = tags

        self.skillsCollectionView.reloadData()
        self.skillsCollectionViewConstant.constant = self.skillsCollectionView.contentSize.height
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        viewWillLayoutSubviews()
    }
}

// MARK:- UITextViewDelegate
extension AddEditJobViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
}

// MARK:- UITextFieldDelegate
extension AddEditJobViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtCategory:
            self.dataPicker.tag = 1
        case txtSubCategory:
            self.dataPicker.tag = 2
        case txtEducationLevel:
            self.dataPicker.tag = 3
        case txtJobType:
            self.dataPicker.tag = 4
        default:
            return
        }
        
        dataPicker.reloadAllComponents()
    }
}
