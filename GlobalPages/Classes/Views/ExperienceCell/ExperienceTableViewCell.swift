//
//  ExperienceTableViewCell.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/21/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

@objc protocol ExperienceTableViewCellDelegate: class {
    @objc optional func didTapOnEdit(_ cell: ExperienceTableViewCell)
}

class ExperienceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPositionTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    
    public var delegate: ExperienceTableViewCellDelegate?
    public var cellType: Type = .experience
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForExperience(_ item: Experience)  {
        let from = DateHelper.convertDateStringToCustomFormat(item.from ?? "", format: "dd MMM, yyyy")
        let to = (item.isPresent ?? false) ? "CV_PRESENT".localized : DateHelper.convertDateStringToCustomFormat(item.to ?? "", format: "dd MMM, yyyy")
        
        self.lblPositionTitle.text = item.title
        self.lblCompanyName.text = item.companyName
        self.lblPeriod.text = "\(from ?? "") - \(to ?? "")"
        self.cellType = .experience
    }
    
    func configureForEducation(_ item: Education)  {
        let from = DateHelper.convertDateStringToCustomFormat(item.from ?? "", format: "dd MMM, yyyy")
        let to = DateHelper.convertDateStringToCustomFormat(item.to ?? "", format: "dd MMM, yyyy")
        
        self.lblPositionTitle.text = item.title
        self.lblCompanyName.text = item.educationalEntity
        self.lblPeriod.text = "\(from ?? "") - \(to ?? "")"
        self.cellType = .education
        
        self.lineView.isHidden = true
    }
    
    @IBAction func EditAction(_ sender: Any) {
        self.delegate?.didTapOnEdit?(self)
    }
    
}
