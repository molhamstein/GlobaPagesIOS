//
//  NotificationsViewController.swift
//  GlobalPages
//
//  Created by Nour  on 10/26/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NotificationsViewController: AbstractController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func customizeView() {
        super.customizeView()
        self.setNavBarTitle(title: "Notifications".localized)
        self.showNavBackButton = true
        
        tableView.tableFooterView = UIView()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.notifications.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = DataStore.shared.notifications[indexPath.row].message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}



