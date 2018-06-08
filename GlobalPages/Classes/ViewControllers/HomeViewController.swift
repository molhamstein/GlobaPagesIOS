//
//  ViewController.swift
//  GlobalPages
//
//  Created by Molham mahmoud on 6/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class HomeViewController: AbstractController {

    // nav bar view
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBarLogo: UIButton!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
     // bussiness guid View
    @IBOutlet weak var businessGuidView: UIView!
    @IBOutlet weak var businessGuidCollectionView: UICollectionView!
    var businessGuidCellId = "BusinessGuidCell"
    var businessGuides:[BusinessGuide] = []
    
    
    
    // date View
    @IBOutlet weak var dateView: UIView!
    
    
    
    
    // filter View
    @IBOutlet weak var fillterView: UIView!
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    var filtterCellId = "filtterCell"
    
    
    // Ads View
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    var adsCellId = "AdsCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func customizeView() {
        
        self.notificationButton.makeRounded()
        self.profileButton.makeRounded()
        
        // setFonts
        self.navBarTitleLabel.font = AppFonts.xBig
    
        // businessGuid CollectionView
        let nib = UINib(nibName: businessGuidCellId, bundle: nil)
        self.businessGuidCollectionView.register(nib, forCellWithReuseIdentifier: businessGuidCellId)
        
        
        let nib2 = UINib(nibName: adsCellId, bundle: nil)
        self.adsCollectionView.register(nib2, forCellWithReuseIdentifier: adsCellId)
        
        let nib3 = UINib(nibName: filtterCellId, bundle: nil)
        self.filtterCollectionView.register(nib3, forCellWithReuseIdentifier: filtterCellId)
        

        getBusinessGuides()
       
    }
    
    
    func getBusinessGuides(){
        
        businessGuides.append(BusinessGuide(title:"Businesses Guide",image:"ic_business_guide",info:"Search for businesses Nearby and find them on the map"))
        
        businessGuides.append(BusinessGuide(title:"On Duty Pharmacy",image:"ic_business_guide",info:"Find Open Pharmacies Nearby"))
        
        businessGuides.append(BusinessGuide(title:"Businesses Guide",image:"ic_business_guide",info:"Search for businesses Nearby and find them on the map"))
        
         self.businessGuidCollectionView.reloadData()
    }
    
    
}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView){
        case businessGuidCollectionView:
            return businessGuides.count
            
        case filtterCollectionView:
            return 2
        case adsCollectionView:
            return 10
        default:
            return 0
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (collectionView){
        case businessGuidCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: businessGuidCellId, for: indexPath) as! BusinessGuidCell
            cell.businessGuide = businessGuides[indexPath.item]
            return cell
            
        case filtterCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filtterCellId, for: indexPath) as! filtterCell
            
            return cell
        case adsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adsCellId, for: indexPath) as! AdsCell
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
       
    }
    
    
    
}



extension HomeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch (collectionView){
        case businessGuidCollectionView:
            return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView.frame.height - 16)
        case filtterCollectionView:
            return CGSize(width: 90 * ScreenSizeRatio.smallRatio, height: self.fillterView.frame.height - 16)
        case adsCollectionView:
            return CGSize(width: self.view.frame.width * 0.5 - 16, height: 224 * ScreenSizeRatio.smallRatio)
        default:
            return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView.frame.height - 16)
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch (collectionView){
        case businessGuidCollectionView:
            return 32
            
        case filtterCollectionView:
            return 8
        case adsCollectionView:
            return 8
        default:
            return 0
            
        }
    }
    
    
}
