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
    func nextVolume()
    func preVolume()
    func showMap()
}

class MenuView: UICollectionReusableView {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previoseButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    var currentVolume = 0
    
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
    @IBAction func tapSearchButton(_ sender: UIButton) {
        ActionShowFilters.execute(type:.Home)
    }
    
    @IBAction func tapMapButton(_ sender: UIButton) {
        ActionShowNewAd.execute()
    }
    
    @IBAction func tapNextWeekButton(_ sender: UIButton) {
        delegate?.nextVolume()
        if currentVolume > 0 {
            currentVolume = currentVolume - 1
        }
        if currentVolume == 0{
            self.nextButton.isEnabled = false
        }
    }
    
    @IBAction func tapPreviosWeekButton(_ sender: UIButton) {
        delegate?.preVolume()
        self.currentVolume += 1
        self.nextButton.isEnabled = true
    }
    
    func animateAddButton(){
        addButton.isUserInteractionEnabled = true
        addButton.isEnabled = true
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [pulse]
        
        addButton.layer.add(animationGroup, forKey: "pulse")
    }
}

// MARK: - IBActions
extension MenuView {
    
    @IBAction func tappedButton(_ sender: UIButton) {
        delegate?.reloadCollectionViewDataWithTeamIndex(sender.tag)
    }
    
    
}
