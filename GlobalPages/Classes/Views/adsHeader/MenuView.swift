//
//  ConversationCollectionViewHeader.swift
//  Vobble
//
//  Created by Molham Mahmoud on 3/18/18.
//  Copyright © 2018 Brain-Socket. All rights reserved.
//

import UIKit


protocol MenuViewDelegate {
    func reloadCollectionViewDataWithTeamIndex(_ index: Int)
}

class MenuView: UICollectionReusableView {
    
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    // MARK: - Properties
    var delegate: MenuViewDelegate?
    
    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        // header Collection register Cell
        let headerNib = UINib(nibName: HomeViewController.filtterCellId, bundle: nil)
        filtterCollectionView.register(headerNib, forCellWithReuseIdentifier: HomeViewController.filtterCellId)
       
        
    }
}

// MARK: - IBActions
extension MenuView {
    
    @IBAction func tappedButton(_ sender: UIButton) {
        delegate?.reloadCollectionViewDataWithTeamIndex(sender.tag)
    }
}
