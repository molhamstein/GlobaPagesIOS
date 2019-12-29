//
//  ApplicantCollectionViewCell.swift
//  GlobalPages
//
//  Created by Abd Hayek on 11/4/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

protocol ApplicantCollectionViewCellDelegate : class {
    func didTapOnStatus(_ cell: ApplicantCollectionViewCell)
}
class ApplicantCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPositionTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var delegate: ApplicantCollectionViewCellDelegate?
    var applicantId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblDate.font = AppFonts.small
        lblName.font = AppFonts.smallSemiBold
        lblAddress.font = AppFonts.small
        lblPositionTitle.font = AppFonts.normalBold
        btnStatus.titleLabel?.font = AppFonts.small
    
        self.addShadow(0.1)
    }
    
    func configureCell(_ applicant: Applicant) {
        applicantId = applicant.id
        lblPositionTitle.text = applicant.user?.cv?.primaryIdentifier ?? "CV_SPECIALIZATION_PLACEHOLDER".localized
        lblName.text = applicant.user?.userName ?? ""
        lblAddress.text = "\(applicant.user?.cv?.city?.title ?? "")"
        lblDate.text = DateHelper.convertDateStringToCustomFormat(applicant.createdAt ?? "", format: "dd, MMM yyyy")
        lblPhoneNumber.text = applicant.user?.mobileNumber ?? ""
        btnStatus.setTitle(ApplicantStatus(rawValue: applicant.status ?? "")?.title, for: .normal)
        
        if let url = applicant.user?.profilePic {
            imgIcon.setImageForURL(url, placeholder: #imageLiteral(resourceName: "user_placeholder"))
        }else {
            imgIcon.image = #imageLiteral(resourceName: "user_placeholder")
        }
        
    }
    
    @IBAction func ChangeStatusAction(_ sender: Any) {
        self.delegate?.didTapOnStatus(self)
    }
}
