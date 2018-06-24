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
    @IBOutlet weak var notificationButton: SSBadgeButton!
    @IBOutlet weak var profileButton: SSBadgeButton!
    
     // bussiness guid View
    @IBOutlet weak var businessGuidView: UIView!
    @IBOutlet weak var businessGuidCollectionView: UICollectionView!
    static var businessGuidCellId = "BusinessGuidCell"
    var businessGuides:[BusinessGuide] = []
    
    // date View
    @IBOutlet weak var dateView: UIView!
    
    // filter View
    @IBOutlet weak var fillterView: UIView!
    weak var filtterCollectionView: UICollectionView?
    static var filtterCellId = "filtterCell"
    
    // Ads View
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    static var adsImageCellId = "AdsImageCell"
    static var adsTitledCellId = "AdsTitledCell"
    
    var adds:[Ads] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func customizeView() {
        
        self.notificationButton.makeRounded()
        self.profileButton.makeRounded()
        self.notificationButton.dropShortShadow()
        self.profileButton.dropShortShadow()
        self.notificationButton.badge = "2"
        
        // setFonts
        self.navBarTitleLabel.font = AppFonts.xBig
        
        // businessGuid CollectionView
        let nib = UINib(nibName: HomeViewController.businessGuidCellId, bundle: nil)
        self.businessGuidCollectionView.register(nib, forCellWithReuseIdentifier: HomeViewController.businessGuidCellId)
        
        // adds Collection view Header
        self.adsCollectionView.register(UINib(nibName: "HomeCollectionViewHeader",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeCollectionViewHeaderID")
        
        // adds Collection view Cells
        let nib2 = UINib(nibName: HomeViewController.adsImageCellId, bundle: nil)
        self.adsCollectionView.register(nib2, forCellWithReuseIdentifier: HomeViewController.adsImageCellId)
        
        let nib3 = UINib(nibName: HomeViewController.adsTitledCellId, bundle: nil)
        self.adsCollectionView.register(nib3, forCellWithReuseIdentifier: HomeViewController.adsTitledCellId)
        
        getBusinessGuides()
        getAds()
        
//        self.adsCollectionView.collectionViewLayout.invalidateLayout()
//        self.adsCollectionView.reloadData()
//        
        // adds Collection view layout
        let layout = PinterestLayout()
        layout.delegate = self
        adsCollectionView.collectionViewLayout = layout
    }
    
    
    func getBusinessGuides(){
        
        businessGuides.append(BusinessGuide(title:"Businesses Guide",image:"ic_business_guide",info:"Search for businesses Nearby and find them on the map"))
        
        businessGuides.append(BusinessGuide(title:"On Duty Pharmacy",image:"ic_business_guide",info:"Find Open Pharmacies Nearby"))
        
        businessGuides.append(BusinessGuide(title:"Businesses Guide",image:"ic_business_guide",info:"Search for businesses Nearby and find them on the map"))
        
        self.businessGuidCollectionView.reloadData()
    }
    

    func getAds(){
        
        adds.append(Ads(title:"Villa for sale in Saburah", image: "AI_Image", info: "Damascus Al-Mazzeh Villas", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .titled))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title:"Villa for sale in Saburah", image: "AI_Image", info: "Damascus Al-Mazzeh Villas", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .titled))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus  Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh VillasDamascus Al-Mazzeh VillasDamascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
        adds.append(Ads(title:"Villa for sale in Saburah", image: "AI_Image", info: "Damascus Al-Mazzeh Villas", tag: "Real Estate", address: "Damascus Al-Mazzeh Villas Damascus Al- Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .titled))
        self.adsCollectionView.collectionViewLayout.invalidateLayout()
        self.adsCollectionView.reloadData()
  
    }
    
    @IBAction func profileButtonAction(_ sender: AnyObject) {
        if DataStore.shared.isLoggedin {
            self.performSegue(withIdentifier: "HomeProfileSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "HomeLoginSegue", sender: self)
        }
    }
}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView ==  businessGuidCollectionView{
            return businessGuides.count
            
        }
        if collectionView == filtterCollectionView {
            return 2
            
        }
        if collectionView ==  adsCollectionView{
            return adds.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  businessGuidCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.businessGuidCellId, for: indexPath) as! BusinessGuidCell
            cell.businessGuide = businessGuides[indexPath.item]
            return cell
            
        }
        if collectionView == filtterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.filtterCellId, for: indexPath) as! filtterCell
            
            return cell
            
        }
        if collectionView ==  adsCollectionView{
            let add = self.adds[indexPath.item]
            if add.type == .image{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsImageCellId, for: indexPath) as! AdsImageCell
            cell.add = self.adds[indexPath.item]
            return cell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsTitledCellId, for: indexPath) as! AdsTitledCell
                cell.add = self.adds[indexPath.item]
                return cell
                
                
            }
        }
     
        return UICollectionViewCell()
    }
}

extension HomeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView ==  businessGuidCollectionView{
               return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView.frame.height - 16)
            
        }
        if collectionView == filtterCollectionView {
           return CGSize(width: 90 * ScreenSizeRatio.smallRatio, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
        }
        if collectionView ==  adsCollectionView{
         return CGSize(width: self.view.frame.width * 0.5 - 16, height: getCellContentSize(indexPath: indexPath))
        }
        
        return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView.frame.height - 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == businessGuidCollectionView{
            return 32
            
        }
        if collectionView == filtterCollectionView{
            return 8
            
        }
        if collectionView == adsCollectionView{
            return 8
            
        }
            return 0
    }
    
    
    /// header View
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == adsCollectionView{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "homeCollectionViewHeaderID", for: indexPath) as! HomeCollectionViewHeader
            filtterCollectionView = headerView.filtterCollectionView
            filtterCollectionView?.delegate = self
            filtterCollectionView?.dataSource = self
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}


//MARK: - PINTEREST LAYOUT DELEGATE
extension HomeViewController : PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return getCellContentSize(indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    func getCellContentSize(indexPath:IndexPath) -> CGFloat{
        var height:CGFloat = 0
        if adds[indexPath.item].type == .image{
            height += 100
        }else{
            
            height += self.adds[indexPath.item].title.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))
            height += 16
        }
        
        height += (self.adds[indexPath.item].address.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17)))
        height += (self.adds[indexPath.item].info.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17)))
        height += (50)
        return height
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        if collectionView == adsCollectionView {
            print("sfsdf")
            return CGSize(width: self.adsCollectionView.bounds.width, height: CGFloat(82.5 * ScreenSizeRatio.smallRatio))
        }
        return CGSize(width: 0, height: 0)
    }
}
