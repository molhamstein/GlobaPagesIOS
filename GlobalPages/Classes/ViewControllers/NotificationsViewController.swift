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
        
        self.getNotifications()
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
        if DataStore.shared.notifications.count > 0 {
            let alert = UIAlertController(title: "GLOBAL_WARNING_TITLE".localized, message: "DELETE_ALL_MSG_WARNING".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DELETE".localized, style: .destructive, handler: {_ in
                self.showActivityLoader(true)
                ApiManager.shared.clearNotification(completionBlock: {isSuccess, error in
                    self.showActivityLoader(false)
                    if isSuccess {
                        DataStore.shared.notifications = []
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    }
                    
                    if error != nil{
                        if let msg = error?.errorName{
                            self.showMessage(message: msg, type: .error)
                        }
                    }
                })
            }))
            
            alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            self.showMessage(message: "ALL_NOTIFICATIONS_DELETED".localized, type: .error)
        }
    }
}


extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource, NotificationTableViewCellDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotificationTableViewCell
        
        cell.configure(DataStore.shared.notifications[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        
        if cell.item?.type == "addNewVolume" {
            let volumeId = cell.item?.data?["volumeId"] as? String
            
            let item = DataStore.shared.notifications.filter {$0.Nid == cell.item?.Nid!}
            item[0].clicked = true
            cell.item?.clicked = true
            
            ApiManager.shared.editNotification(item: cell.item!, completionBlock: {(isSuccess, error) in
                if isSuccess {
                    self.tableView.reloadData()
                }
            })
            
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
    
    func didMenuClicked(_ cell: NotificationTableViewCell) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "DELETE".localized, style: .destructive, handler: {_ in
            guard let index = self.tableView.indexPath(for: cell) else {return}
            
            self.showActivityLoader(true)
            ApiManager.shared.deleteNotification(id: cell.item?.Nid ?? "", completionBlock: {success, error in
                self.showActivityLoader(false)
                if let error = error {
                    self.showMessage(message: error.type.errorMessage, type: .error)
                    return
                }
                
                DataStore.shared.notifications.removeAll {$0.Nid == cell.item?.Nid!}
                self.tableView.deleteRows(at: [index], with: .automatic)
            })
        }))
        
        sheet.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        
        self.present(sheet, animated: true, completion: nil)
        
    }
}



