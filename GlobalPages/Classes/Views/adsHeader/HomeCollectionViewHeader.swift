//
//  ConversationCollectionViewHeader.swift
//  Vobble
//
//  Created by Molham Mahmoud on 3/18/18.
//  Copyright © 2018 Brain-Socket. All rights reserved.
//

import UIKit


class HomeCollectionViewHeader: UICollectionReusableView {
    
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        // header Collection register Cell
        let headerNib = UINib(nibName: HomeViewController.filtterCellId, bundle: nil)
        filtterCollectionView.register(headerNib, forCellWithReuseIdentifier: HomeViewController.filtterCellId)
       
        
    }
}
