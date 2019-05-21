//
//  StartViewController.swift
//  BrainSocket Code base
//
//  Created by Molham Mahmoud on 4/25/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit

class StartViewController: AbstractController {
    
    // MARK: Properties
    
    @IBOutlet weak var logoImageView: UIImageView!
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = "logo_\(AppConfig.currentLanguage.langCode)"
        logoImageView.image = UIImage(named:image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "startHomeSegue", sender: self)


        // check if user logged in
//        if DataStore.shared.isLoggedin {
//          //  DataStore.shared.fetchBaseData()
//            self.performSegue(withIdentifier: "startHomeSegue", sender: self)
//        } else {// user not logged in
//            self.performSegue(withIdentifier: "startLoginSegue", sender: self)
//        }
    }
}

