//
//  ProfileViewController.swift
//  Wardah
//
//  Created by Molham Mahmoud on 7/5/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation
import WebKit
class TermsViewController: AbstractController {
    
    let TERMS_URL_AR: String! = "http://almersal.co/privacy/policy_ar.html"
    let TERMS_URL_EN: String! = "http://almersal.co/privacy/policy_en.html"
    
    // MARK: Properties
    @IBOutlet var webView: UIWebView!

    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarTitle(title: "TERMS_TITLE".localized)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        
        self.showNavBlackBackButton = true
        
        let url: String! = (AppConfig.currentLanguage == .arabic) ? self.TERMS_URL_AR : self.TERMS_URL_EN
        webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        // hide keyboard
        self.navigationController?.popViewController(animated: true)
    }
    
    // Build up view elements
    override func buildUp() {
//        loginView.animateIn(mode: .animateInFromBottom, delay: 0.1)
//        centerView.animateIn(mode: .animateInFromBottom, delay: 0.3)
//        footerView.animateIn(mode: .animateInFromBottom, delay: 0.4)
    }
    
    @IBAction func viewTermsAction(_ sender: UIView) {
        performSegue(withIdentifier: "aboutTermsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "feedsPostDetailsSegue", let nextScene = segue.destination as? PostDetailsViewController {
        //            nextScene.activePost = selectedPost
        //        } else if segue.identifier == "feedsProfileSegue", let nextScene = segue.destination as? ProfileViewController {
        //            nextScene.activeUser = selectedUser
        //        }
    }
    
}
