//
//  JobOfferCollectionViewCell.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/28/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class JobOfferCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblPositionTitle: UILabel!
    @IBOutlet weak var lblCompanyTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var isNew: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblDate.font = AppFonts.small
        lblCompanyTitle.font = AppFonts.smallSemiBold
        lblBudget.font = AppFonts.small
        lblAddress.font = AppFonts.small
        lblPositionTitle.font = AppFonts.normalBold
        
        self.addShadow(0.3)
    }

    func configureCell(_ job: Job) {
        lblPositionTitle.text = job.name
        lblCompanyTitle.text = job.business?.title
        lblAddress.text = "\(job.business?.city?.title ?? "") | \(job.business?.location?.title ?? "")"
        lblDate.text = DateHelper.convertDateStringToCustomFormat(job.creationDate ?? "", format: "dd, MMM yyyy")
        lblBudget.isHidden = !isJobOfferNew(job.creationDate ?? "")
        isNew = isJobOfferNew(job.creationDate ?? "")
        
        if let url = job.business?.logo , url != ""{
            imgIcon.setImageForURL(url, placeholder: #imageLiteral(resourceName: "business_placeholder"))
        }else {
            imgIcon.image = #imageLiteral(resourceName: "business_placeholder")
        }
        
    }
    
    func isJobOfferNew(_ date: String) -> Bool {
        // Get last week date from now
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        
        if DateHelper.getDateFromISOString(date) ?? Date() > lastWeekDate {
            return true
        }
        
        return false
    }
}
