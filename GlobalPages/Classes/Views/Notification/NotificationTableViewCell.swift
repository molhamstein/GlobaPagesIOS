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
    @IBOutlet weak var btnMenu: UIButton!
    
    public var item: AppNotification?
    public var delegate: NotificationTableViewCellDelegate?
    
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
        self.backgroundColor = item.clicked == true ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
    }

    @IBAction func menuAction(_ sender: Any){
        delegate?.didMenuClicked(self)
    }
}

protocol NotificationTableViewCellDelegate : class {
    func didMenuClicked(_ cell : NotificationTableViewCell)
}
