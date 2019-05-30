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
    @IBOutlet weak var containerView: UIView!

    private var btnDelete: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func customizeView() {
        super.customizeView()
        self.setNavBarTitle(title: "Notifications".localized)
        self.showNavBackButton = true
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        seenNotification()
        setupDeleteButton()
    }

    override func buildUp() {
        super.buildUp()
        self.containerView.dropShadow()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNotifications(){
        guard let userid = DataStore.shared.me?.objectId else{ return }
        self.showActivityLoader(true)
        ApiManager.shared.getNotification(user_id: userid) { (success, error, result) in
            self.showActivityLoader(false)
            self.seenNotification()
            self.tableView.reloadData()
        }
        
    }
    
    func seenNotification(){
        if DataStore.shared.notifications.count > 0{
            let ids = DataStore.shared.notifications.map{$0.Nid ?? ""}
            ApiManager.shared.seenNotification(ids: ids) { (success, error) in}
        }
    }
    
    func setupDeleteButton(){
        let _navDeleteButton = UIButton()
        _navDeleteButton.dropShadow()
        _navDeleteButton.setBackgroundImage(UIImage(named: "trash"), for: .normal)
        _navDeleteButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        _navDeleteButton.addTarget(self, action: #selector(deleteAllNotification), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: _navDeleteButton)
     
    }
    
    @objc func deleteAllNotification(){
        if DataStore.shared.notifications.count > 0{
            let ids = DataStore.shared.notifications.map{$0.Nid ?? ""}
            
            for i in ids {
                ApiManager.shared.deleteNotification(id: i, completionBlock: {_,_ in})
            }
            
            DataStore.shared.notifications = []
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }else {
            self.showMessage(message: "ALL_NOTIFICATIONS_DELETED".localized, type: .error)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotificationTableViewCell
        
        cell.configure(DataStore.shared.notifications[indexPath.row])
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        
        if cell.item?.type == "addNewVolume" {
            let volumeId = cell.item?.data?["volumeId"] as? String
            
            self.showActivityLoader(true)
            ApiManager.shared.getOneVolume(id: volumeId ?? "" , completionBlock: {(success, error, result) in
                self.showActivityLoader(false)
                
                if success {
                    self.performSegue(withIdentifier: "toNotificationDetails", sender: self)
                }
                
                if error != nil{
                    if let msg = error?.errorName{
                        self.showMessage(message: msg, type: .error)
                    }
                }
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}



