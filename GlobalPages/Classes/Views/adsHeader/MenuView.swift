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
    func newspaperDidPressed()
    func marketDidPressed()
}

class MenuView: UICollectionReusableView {
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            print("set")
        }
    }
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previoseButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var newspaperViewButton: UIView!
    @IBOutlet weak var newspaperBarColor: UIView!
    @IBOutlet weak var marketViewButton: UIView!
    @IBOutlet weak var marketBarColor: UIView!
    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var lblNewspaper: UILabel!
    @IBOutlet weak var marketViewButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var volumeViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewConstraint: NSLayoutConstraint!

    var currentVolume = 0
    fileprivate var isMarketSelected: Bool = false
    fileprivate var currentTapPoint: CGPoint = CGPoint(x: 0, y: 0)
    fileprivate var marketViewColor = UIColor(red: 255/255, green: 72/255, blue: 77/255, alpha: 1)
    fileprivate var newspaperViewColor = UIColor(red: 0/255, green: 159/255, blue: 255/255, alpha: 1)
    
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
        
        let newspaperTap = UITapGestureRecognizer(target: self, action: #selector(didPressOnNewspaper(_:)))
        let marketTap = UITapGestureRecognizer(target: self, action: #selector(didPressOnMarket(_:)))
        self.newspaperViewButton.addGestureRecognizer(newspaperTap)
        self.marketViewButton.addGestureRecognizer(marketTap)
        
        self.lblMarket.font = AppFonts.smallSemiBold 
        self.lblNewspaper.font = AppFonts.smallSemiBold
        
        self.newspaperBarColor.backgroundColor = newspaperViewColor
        self.marketBarColor.backgroundColor = UIColor.lightGray
        
        self.lblMarket.text = "HOME_MARKET".localized
        self.lblNewspaper.text = "HOME_NEWSPAPERE".localized
        
        self.animateAddButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        self.marketViewButton.layoutIfNeeded()
        self.newspaperViewButton.layoutIfNeeded()
        
        if !isMarketSelected {
            self.marketViewButtonConstraint.constant = self.frame.width / 3.5
        }
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
    
    @objc func didPressOnNewspaper(_ sender: UITapGestureRecognizer){
        
        if self.isMarketSelected {
            self.currentTapPoint = sender.location(in: sender.view)
            self.marketViewButtonConstraint.constant = self.frame.width / 3.5
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [], animations: {
                
                self.layoutIfNeeded()
                self.marketViewButton.layoutIfNeeded()
                self.newspaperViewButton.layoutIfNeeded()
                
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fillUpViewWithPaint(sender , view: self.newspaperBarColor, color: self.newspaperViewColor)
                
                self.marketBarColor.backgroundColor = UIColor.lightGray
            }
            
            self.delegate?.newspaperDidPressed()
            self.isMarketSelected = false
        }
        
    }
    
    @objc func didPressOnMarket(_ sender: UITapGestureRecognizer){
        
        if !isMarketSelected {
            self.currentTapPoint = sender.location(in: sender.view)
            self.marketViewButtonConstraint.constant = self.marketViewButtonConstraint.constant * 2
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [], animations: {
                
                self.layoutIfNeeded()
                self.marketViewButton.layoutIfNeeded()
                self.newspaperViewButton.layoutIfNeeded()
                
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fillUpViewWithPaint(sender, view: self.marketBarColor, color: self.marketViewColor)
                
                self.newspaperBarColor.backgroundColor = UIColor.lightGray
            }
            
            self.delegate?.marketDidPressed()
            self.isMarketSelected = true
        }
        
    }
    
    func fillUpViewWithPaint(_ sender: UITapGestureRecognizer, view: UIView, color: UIColor) {
        
        let ripple = UIView(frame: CGRect(x: currentTapPoint.x, y: currentTapPoint.y, width: 10, height: 10))
        
        ripple.layer.cornerRadius = 5
        ripple.layer.masksToBounds = true
        ripple.backgroundColor = color
        
        view.insertSubview(ripple, at: 0)
        
        ripple.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.4, animations: {
            ripple.transform = CGAffineTransform(scaleX: 45, y: 45)
        }, completion: {_ in
            view.backgroundColor = color
            ripple.removeFromSuperview()
            
        })
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
