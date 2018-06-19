//
//  ConversationCollectionViewHeader.swift
//  Vobble
//
//  Created by Molham Mahmoud on 3/18/18.
//  Copyright © 2018 Brain-Socket. All rights reserved.
//

import UIKit


class HomeCollectionViewHeader: UICollectionReusableView {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        
        // set collection views pagging
        headerCollectionView.isPagingEnabled = true
        // header Collection register Cell
        let headerNib = UINib(nibName: HomeViewController.featureCellId, bundle: nil)
        headerCollectionView.register(headerNib, forCellWithReuseIdentifier: HomeViewController.featureCellId)
        // tabBar collectionView register Cell
        let tabBarNib = UINib(nibName: HomeViewController.categoryCollectionViewCellId, bundle: nil)
        categoryCollectionView.register(tabBarNib, forCellWithReuseIdentifier: HomeViewController.categoryCollectionViewCellId)
        
    }
    
//    func configCell(userObj: AppUser) {
//
//    }
    
//    @IBAction func myBottlesButtonPressed(_ sender: Any) {
//        convVC?.tap = .myBottles
//        convVC?.bottleCollectionView.reloadData()
//        btnMyReplies.isSelected = false
//        btnMyBottles.isSelected = true
//    }
//
//    @IBAction func MyRepliesButtonPressed(_ sender: Any) {
//        convVC?.tap = .myReplies
//        convVC?.bottleCollectionView.reloadData()
//        btnMyReplies.isSelected = true
//        btnMyBottles.isSelected = false
//    }
    
}
