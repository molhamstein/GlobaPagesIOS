//
//  ApplicantsViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 11/4/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class ApplicantsViewController: AbstractController {
    
    @IBOutlet weak var lblPoition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var applicantsCollectionView: UICollectionView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    fileprivate var applicants: [Applicant] = []
    
    public var job: Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applicantsCollectionView.delegate = self
        applicantsCollectionView.dataSource = self

        applicantsCollectionView.register(UINib(nibName: "ApplicantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApplicantCollectionViewCell")
        
        self.lblPlaceholder.isHidden = false
        self.imgPlaceholder.isHidden = false
        self.applicantsCollectionView.isHidden = true
        
        fillUpData()
        getApplicants()
    }
    
    override func buildUp() {

    }
    
    override func customizeView() {
        lblPoition.font = AppFonts.xBigBold
        lblName.font = AppFonts.normalSemiBold
        lblAddress.font = AppFonts.normal
        lblCategory.font = AppFonts.normal
        lblSubCategory.font = AppFonts.normal
        lblDate.font = AppFonts.small
        lblPlaceholder.font = AppFonts.normalSemiBold
        
        lblPlaceholder.text = "APPLICANTS_PLACEHOLDER".localized
    }
    
    func fillUpData(){
        
        lblPoition.text = job?.name
        lblName.text = job?.business?.title
        lblAddress.text = "\(job?.business?.city?.title ?? "") | \(job?.business?.location?.title ?? "")"
        lblDate.text = DateHelper.convertDateStringToCustomFormat(job?.creationDate ?? "", format: "dd, MMM yyyy")
        lblCategory.text = job?.category?.title
        lblSubCategory.text = job?.subCategory?.title
        
        if let url = job?.business?.logo , url != ""{
            imgLogo.setImageForURL(url, placeholder: #imageLiteral(resourceName: "business_placeholder"))
        }else {
            imgLogo.image = #imageLiteral(resourceName: "business_placeholder")
        }
    }
    
    func getApplicants(){
        self.showActivityLoader(true)
        
        ApiManager.shared.getApplicants(id: self.job?.jobId ?? "", completionBlock: {success, error, result in
            self.showActivityLoader(false)
            
            if let error = error {
                self.showMessage(message: error.type.errorMessage, type: .error)
                self.lblPlaceholder.isHidden = false
                self.imgPlaceholder.isHidden = false
                self.applicantsCollectionView.isHidden = true
                return
            }
            
            self.applicants = result
            self.applicantsCollectionView.reloadData()
            
            if self.applicants.count > 0 {
                self.lblPlaceholder.isHidden = true
                self.imgPlaceholder.isHidden = true
                self.applicantsCollectionView.isHidden = false
            }else {
                self.lblPlaceholder.isHidden = false
                self.imgPlaceholder.isHidden = false
                self.applicantsCollectionView.isHidden = true
            }
        })
        
    }

    func changeApplicantStatus(cell: ApplicantCollectionViewCell, status: String) {
        self.showActivityLoader(true)
        ApiManager.shared.updateApplicantStatus(id: cell.applicantId ?? "", status: status, completionBlock: {success, error in
            self.showActivityLoader(false)
            if let error = error {
                self.showMessage(message: error.type.errorMessage, type: .error)
                return
            }
            
            self.getApplicants()
        })
    }
}

// MARK:- IBAction
extension ApplicantsViewController {
    @IBAction func BackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK:- ApplicantCollectionViewCellDelegate
extension ApplicantsViewController: ApplicantCollectionViewCellDelegate {
    func didTapOnStatus(_ cell: ApplicantCollectionViewCell) {
        let sheet = UIAlertController(title: nil, message: "APPLICANT_STATE_MSG".localized, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "APPLICANT_PENDING".localized, style: .default, handler: {_ in
            self.changeApplicantStatus(cell: cell, status: "pending")
        }))
        sheet.addAction(UIAlertAction(title: "APPLICANT_INTERVIEWING".localized, style: .default, handler: {_ in
            self.changeApplicantStatus(cell: cell, status: "interviewing")
        }))
        sheet.addAction(UIAlertAction(title: "APPLICANT_HIRE".localized, style: .default, handler: {_ in
            self.changeApplicantStatus(cell: cell, status: "hire")
        }))
        sheet.addAction(UIAlertAction(title: "APPLICANT_NO_HIRE".localized, style: .default, handler: {_ in
            self.changeApplicantStatus(cell: cell, status: "noHire")
        }))
        
        self.present(sheet, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDelegate
extension ApplicantsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplicantCollectionViewCell", for: indexPath) as! ApplicantCollectionViewCell
        
        cell.delegate = self
        cell.configureCell(applicants[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: CVViewController.className)  as! CVViewController
        
        vc.user = applicants[indexPath.row].user
        vc.modalPresentationStyle = .fullScreen
        
        //let nav = UINavigationController(rootViewController: vc)
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.applicantsCollectionView.frame.width, height: 110)
    }
    
}
