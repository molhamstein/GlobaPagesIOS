//
//  NotificationTableViewCell.swift
//  GlobalPages
//
//  Created by Abdulrahman Alhayek on 4/23/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    public var item: AppNotification?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(_ item: AppNotification) {
        self.item = item
        
        self.lblTitle.text = item.message
        self.lblDate.text = item.creationDate?.components(separatedBy: "T")[0]
        self.backgroundColor = (item.seen == 0) ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8799999952, green: 0.8799999952, blue: 0.8799999952, alpha: 1)
    }

}
