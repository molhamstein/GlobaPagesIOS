//
//  ProfileViewController.swift
//  Wardah
//
//  Created by Molham Mahmoud on 7/5/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation
import MessageUI

class AboutViewController: AbstractController, MFMailComposeViewControllerDelegate {
    // MARK: Properties
    

    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarTitle(title: "ABOUT_TITLE".localized)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        self.showNavBackButton = true
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        // hide keyboard
        self.navigationController?.dismiss(animated: true, completion: {})
    }
    
    // Build up view elements
    override func buildUp() {
//        loginView.animateIn(mode: .animateInFromBottom, delay: 0.1)
//        centerView.animateIn(mode: .animateInFromBottom, delay: 0.3)
//        footerView.animateIn(mode: .animateInFromBottom, delay: 0.4)
    }

    @IBAction func contactUsAction(_ sender: UIView) {
        if (MFMailComposeViewController.canSendMail()) {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients([AppConfig.contactUsEmail])
            composeVC.setSubject("Hello!")
            composeVC.setMessageBody("", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        } else {
            showMessage(message: "mail_not_configured".localized, type: .warning)
        }
    }
    
    @IBAction func viewTermsAction(_ sender: UIView) {
        performSegue(withIdentifier: "aboutTermsSegue", sender: self)
    }
    
    @IBAction func viewPartnersAction(_ sender: UIView) {
//        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "FloristViewController") as! FloristViewController
//        vc.enableSelectFlorist = false
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
