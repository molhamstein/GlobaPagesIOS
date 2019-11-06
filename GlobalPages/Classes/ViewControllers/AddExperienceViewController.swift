//
//  AddExperienceViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/24/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

protocol AddExperienceDelegate : class {
    func didAddExperience(_ experience: Experience)
    func didAddEducation(_ education: Education)
    func didEditEducation(_ education: Education, index: IndexPath)
    func didEditExperience(_ experience: Experience, index: IndexPath)
    func didDeleteEducation(_ education: Education, index: IndexPath)
    func didDeleteExperience(_ experience: Experience, index: IndexPath)
    
}

enum Mode {
    case add
    case edit
}

enum Type {
    case education
    case experience
}

class AddExperienceViewController: AbstractController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnWorkHere: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblWorkHere: UILabel!
    @IBOutlet weak var toDataView: UIView!
    
    public var experience: Experience?
    public var education: Education?
    public var mode: Mode = .add
    public var type: Type = .experience
    public var delegate: AddExperienceDelegate?
    public var index: IndexPath?
    
    fileprivate var isCurrentlyWorkingHere: Bool = false
    fileprivate var datePicker: UIDatePicker!
    fileprivate var selectedFromDate: Date?
    fileprivate var selectedToDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDatePicker()
    }
    
    override func customizeView() {
        txtTo.placeholder = "CV_TO_DATE".localized
        txtFrom.placeholder = "CV_FROM_DATE".localized
        
        txtTitle.font = AppFonts.normalSemiBold
        txtCompanyName.font = AppFonts.normalSemiBold
        txtTo.font = AppFonts.normalSemiBold
        txtFrom.font = AppFonts.normalSemiBold
        lblWorkHere.font = AppFonts.normal
        btnAdd.titleLabel?.font = AppFonts.normalSemiBold
    }
    
    func setupView(){
        switch type {
        case .education:
            txtTitle.placeholder = "CV_SCHOOL_NAME".localized
            txtCompanyName.placeholder = "CV_FIELD_OF_STUDY".localized
            btnDelete.setTitle("DELETE".localized, for: .normal)
          
            btnWorkHere.isHidden = true
            lblWorkHere.isHidden = true
            
        case .experience:
            txtTitle.placeholder = "CV_POSITION_TITLE".localized
            txtCompanyName.placeholder = "CV_COMPANY_NAME".localized
            lblWorkHere.text = "CV_CURRENTLY_WORK_HERE".localized
            
            btnWorkHere.isHidden = false
            lblWorkHere.isHidden = false
        }
        
        switch mode {
        case .add:
            txtCompanyName.text = ""
            txtTitle.text = ""
            txtTo.text = ""
            txtFrom.text = ""
            btnAdd.setTitle("CV_ADD".localized, for: .normal)
            btnDelete.isHidden = true
            
        case .edit:
            btnAdd.setTitle("CV_Edit".localized, for: .normal)
            btnDelete.isHidden = false
            
            switch type {
            case .education:
                txtCompanyName.text = education?.educationalEntity
                txtTitle.text = education?.title
                txtTo.text = DateHelper.convertDateStringToCustomFormat(education?.to ?? "", format: "dd MMM yyyy")
                txtFrom.text = DateHelper.convertDateStringToCustomFormat(education?.from ?? "", format: "dd MMM yyyy")
                
            case .experience:
                txtCompanyName.text = experience?.companyName
                txtTitle.text = experience?.title
                txtTo.text = (experience?.isPresent ?? false) ? "" : DateHelper.convertDateStringToCustomFormat(experience?.to ?? "", format: "dd MMM yyyy")
                txtFrom.text = DateHelper.convertDateStringToCustomFormat(experience?.from ?? "", format: "dd MMM yyyy")
                
                if experience?.isPresent ?? false {
                    CurrentlyWorkHereAction(self.btnWorkHere)
                }
            }

            
            
        }
    }
    
    func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        if type == .experience {
            datePicker.maximumDate = Date()
        }
        
        txtTo.inputView = datePicker
        txtFrom.inputView = datePicker
        
        txtTo.delegate = self
        txtFrom.delegate = self
    }

    @IBAction func CloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DeleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "DELETE_CONFIRMATION".localized, message: "DELETE_CONFIRMATION_MSG".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "DELETE".localized, style: .destructive, handler: {_ in
            switch self.type {
                case .education:
                    self.delegate?.didDeleteEducation(self.education!, index: self.index!)
                case .experience:
                    self.delegate?.didDeleteExperience(self.experience!, index: self.index!)
            }
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func AddAction(_ sender: Any) {
        if txtTitle.text!.isEmpty || txtCompanyName.text!.isEmpty || txtFrom.text!.isEmpty || (txtTo.text!.isEmpty && !isCurrentlyWorkingHere) {
            self.showMessage(message: "".localized, type: .error)
        }else {
            switch type{
            case .education:
                let tempEducation = Education()
                tempEducation.title = txtTitle.text
                tempEducation.educationalEntity = txtCompanyName.text
                tempEducation.from = DateHelper.getISOStringFromDate(selectedFromDate ?? Date())
                tempEducation.to = DateHelper.getISOStringFromDate(selectedToDate ?? Date())
                
                switch mode {
                case .add:
                    delegate?.didAddEducation(tempEducation)
                case .edit:
                    delegate?.didEditEducation(tempEducation, index: index ?? IndexPath(row: 0, section: 0))
                }
                
            case .experience:
                let tempExperience = Experience()
                tempExperience.title = txtTitle.text
                tempExperience.companyName = txtCompanyName.text
                tempExperience.from = DateHelper.getISOStringFromDate(selectedFromDate ?? Date())
                tempExperience.to = isCurrentlyWorkingHere ? nil : DateHelper.getISOStringFromDate(selectedToDate ?? Date())
                tempExperience.isPresent = isCurrentlyWorkingHere
                
                switch mode {
                case .add:
                    delegate?.didAddExperience(tempExperience)
                case .edit:
                    delegate?.didEditExperience(tempExperience, index: index ?? IndexPath(row: 0, section: 0))
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func CurrentlyWorkHereAction(_ sender: Any) {
        isCurrentlyWorkingHere = !isCurrentlyWorkingHere
        
        self.btnWorkHere.setImage(isCurrentlyWorkingHere ? UIImage(named: "checkBoxActive.png") : UIImage(named: "checkBox.png"), for: .normal)
        self.toDataView.isHidden = isCurrentlyWorkingHere
    }
}

extension AddExperienceViewController {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFrom {
            textField.text = DateHelper.getBirthFormatedStringFromDate(datePicker.date)
            self.selectedFromDate = datePicker.date
        }
        if textField == txtTo {
            textField.text = DateHelper.getBirthFormatedStringFromDate(datePicker.date)
            self.selectedToDate = datePicker.date
        }
    }
}
