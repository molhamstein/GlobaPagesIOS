//
//  ViewController.swift
//  GlobalPages
//
//  Created by Molham mahmoud on 6/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: AbstractController {

    // nav bar view
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBarLogo: UIButton!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    @IBOutlet weak var notificationButton: SSBadgeButton!
    @IBOutlet weak var profileButton: SSBadgeButton!
    
    var isFirstTimeToLoad = true
    
     // bussiness guid View
     weak var businessGuidView: UIView?
     weak var businessGuidCollectionView: UICollectionView?
    
    static var businessGuidCellId = "BusinessGuidCell"
    
    var businessGuides:[BusinessGuide] = []
    
    var gradiantColors:[[UIColor]] = [[AppColors.blueLight,AppColors.blueDark],[AppColors.pinkLight,AppColors.pinkDark],[AppColors.blueLight,AppColors.blueDark]]
   
    
    // date View
    @IBOutlet weak var dateView: UIView!
    
    // filter View
    @IBOutlet weak var fillterView: UIView!
    
    
    weak var filtterCollectionView: UICollectionView?
    
    static var filtterCellId = "filtterCell"
    
    
    var categoryfiltertype:categoryFilterType = .Home
    
    var filters:[categoriesFilter] = []
    
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
    
        collectionViewSetup()
        getBusinessGuides()
        getAds()
       
    }
    
    func navbarCustomization(){
        // nav bar customization
        
        self.notificationButton.makeRounded()
        self.profileButton.makeRounded()
        self.notificationButton.dropShortShadow()
        self.profileButton.dropShortShadow()
        self.notificationButton.badge = "2"
        // setFonts
        self.navBarTitleLabel.font = AppFonts.xBig
        
    }
    
    override func buildUp() {
        if isFirstTimeToLoad {
            self.perform(#selector(applyGradiant), with: nil, afterDelay: 0.1)
            isFirstTimeToLoad = false
        }
        getFilters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navbarCustomization()
    }
    
    func applyGradiant(){
        // set gradiant
        self.headerView.applyGradient(colours: [AppColors.yellowDark,AppColors.yellowLight], direction: .diagonal)
        
    }
    func collectionViewSetup(){
        
        // adds Collection view layout
        let layout = CustomLayout()
        layout.delegate = self
        adsCollectionView.collectionViewLayout = layout
        setupCollectionViewLayout()
        //
        self.adsCollectionView.register(UINib(nibName: "menuView",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "menu")
        //
        // adds Collection view Cells
        let nib2 = UINib(nibName: HomeViewController.adsImageCellId, bundle: nil)
        self.adsCollectionView.register(nib2, forCellWithReuseIdentifier: HomeViewController.adsImageCellId)
        
        let nib3 = UINib(nibName: HomeViewController.adsTitledCellId, bundle: nil)
        self.adsCollectionView.register(nib3, forCellWithReuseIdentifier: HomeViewController.adsTitledCellId)
        
    }
    
    func getFilters(){
        filters.removeAll()
        if let city = categoryfiltertype.filter.city{
            filters.append(city)
            if let area = categoryfiltertype.filter.area{
                filters.append(area)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل المدن"
            cat.titleEn = "all cities"
             filters.append(cat)
        }
        
        if let cat = categoryfiltertype.filter.category{
            filters.append(cat)
            if let subCat = categoryfiltertype.filter.subCategory{
                filters.append(subCat)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل الاعلانات"
            cat.titleEn = "all Ads"
            filters.append(cat)
        }
        filtterCollectionView?.reloadData()
    }
    
    func getBusinessGuides(){
        
        businessGuides.append(BusinessGuide(title:"Businesses Guide",image:"AI_Image",info:"Appartment for sale"))
        
        businessGuides.append(BusinessGuide(title:"On Duty Pharmacy",image:"AI_Image",info:"Appartment for sale"))
        
        businessGuides.append(BusinessGuide(title:"Businesses Guide",image:"AI_Image",info:"Appartment for sale"))
        
        self.businessGuidCollectionView?.reloadData()
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
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate dsfsdfs ", address: "Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh VillasDamascus Al-Mazzeh VillasDamascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas Damascus Al-Mazzeh Villas", type: .image))
        
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
            return filters.count
            
        }
        if collectionView ==  adsCollectionView{
            return adds.count
        }
        return 0
    }
    
     // load collecton view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  businessGuidCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.businessGuidCellId, for: indexPath) as! BusinessGuidCell
            cell.businessGuide = businessGuides[indexPath.item]
          //  cell.setpView(colors:self.gradiantColors[indexPath.item])
            
            return cell
            
        }
        if collectionView == filtterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.filtterCellId, for: indexPath) as! filtterCell
            cell.filter = filters[indexPath.item]
            cell.tag = indexPath.item
            cell.delegate = self
            return cell
            
        }
        if collectionView ==  adsCollectionView{
            let add = self.adds[indexPath.item]
            if add.type == .image{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsImageCellId, for: indexPath) as! AdsImageCell
            cell.add = self.adds[indexPath.item]
                cell.resizeTagView()
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsTitledCellId, for: indexPath) as! AdsTitledCell
                cell.add = self.adds[indexPath.item]
                cell.resizeTagView()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtterCollectionView {
            ActionShowFilters.execute(type: .Home)
        }
        if collectionView == adsCollectionView {
            ActionShowAdsDescrption.execute()
        }
    }
}

// setup Cell and header Size

extension HomeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  businessGuidCollectionView{
            return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView!.frame.height - 16)
        }
        if collectionView == filtterCollectionView {
           return CGSize(width: filters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
        }
        if collectionView ==  adsCollectionView{
         return CGSize(width: self.view.frame.width * 0.5 - 16, height: getCellContentSize(indexPath: indexPath))
        }
        return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView!.frame.height - 16)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == businessGuidCollectionView{return 32}
        if collectionView == filtterCollectionView{return 8}
        if collectionView == adsCollectionView{return 8}
        return 0
    }
}

// setup CustomeLay out

 extension HomeViewController {
    func setupCollectionViewLayout() {
        guard let collectionView = adsCollectionView, let customLayout = adsCollectionView.collectionViewLayout as? CustomLayout else { return }
        adsCollectionView.register(
            UINib(nibName: "HeaderView", bundle: nil),
            forSupplementaryViewOfKind: CustomLayout.Element.header.kind,
            withReuseIdentifier: CustomLayout.Element.header.id
        )
        adsCollectionView.register(
            UINib(nibName: "MenuView", bundle: nil),
            forSupplementaryViewOfKind: CustomLayout.Element.menu.kind,
            withReuseIdentifier: CustomLayout.Element.menu.id
        )

        customLayout.settings.itemSize = CGSize(width: self.view.frame.width, height: 200)
        customLayout.settings.headerSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.26)
        customLayout.settings.menuSize = CGSize(width: self.view.frame.width, height: 87.5)
        customLayout.settings.sectionsHeaderSize = CGSize(width: collectionView.frame.width, height: 0)
        customLayout.settings.sectionsFooterSize = CGSize(width: collectionView.frame.width, height: 0)
        customLayout.settings.isHeaderStretchy = true
        customLayout.settings.isAlphaOnHeaderActive = true
        customLayout.settings.headerOverlayMaxAlphaValue = CGFloat(1)
        customLayout.settings.isMenuSticky = true
        customLayout.settings.isSectionHeadersSticky = false
        customLayout.settings.isParallaxOnCellsEnabled = false
        customLayout.settings.maxParallaxOffset = 0
        customLayout.settings.minimumInteritemSpacing = 0
        customLayout.settings.minimumLineSpacing = 3
        adsCollectionView.collectionViewLayout  = customLayout
    }
}




//MARK: - UICollectionViewDataSource
extension HomeViewController {
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomLayout.Element.sectionHeader.id, for: indexPath)
            
            return supplementaryView

        case UICollectionElementKindSectionFooter:
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomLayout.Element.sectionFooter.id, for: indexPath)
            return supplementaryView
            
        case CustomLayout.Element.header.kind:
            if collectionView == adsCollectionView {
            let topHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomLayout.Element.header.id,
                for: indexPath
            ) as! HeaderView
            self.businessGuidCollectionView =  topHeaderView.businessGuidCollectionView
                self.businessGuidCollectionView?.delegate  = self
                self.businessGuidCollectionView?.dataSource = self
                topHeaderView.customizeCell()
                topHeaderView.delegate = self
                return topHeaderView
                
            }
            return UICollectionReusableView()
            
        case CustomLayout.Element.menu.kind:
            if collectionView == adsCollectionView {
            let menuView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomLayout.Element.menu.id,
                for: indexPath
            )
            if let menuView = menuView as? MenuView {
                menuView.delegate = self
                self.filtterCollectionView = menuView.filtterCollectionView
                self.filtterCollectionView?.delegate = self
                self.filtterCollectionView?.dataSource = self
            }
            return menuView
            
        }
        return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - MenuViewDelegate
extension HomeViewController: MenuViewDelegate {
    
    func reloadCollectionViewDataWithTeamIndex(_ index: Int) {
        
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
        height += (32)
        return height
    }
    
}

// filter cell Delegate
extension HomeViewController:filterCellProtocol{
    func removeFilter(filter: categoriesFilter) {
        filter.filtervalue?.removeFilter(fltr: Filter.home)
        getFilters()
    }
}


// header View Delegate

extension HomeViewController:HeaderViewDelegate{
    
    func bussinessGuiedeCliked() {
       // self.performSegue(withIdentifier: "bussinessGuideSegue", sender: nil)
        self.showMapView(controllerType: .bussinessGuide)
    }
    
    
    func findNearByClicked() {
        self.showMapView(controllerType: .nearBy)
        //self.performSegue(withIdentifier: "nearBySege", sender: nil)
    }
    
    func onDutyPharmacyClicked() {
        self.showMapView(controllerType: .pharmacy)
//        self.performSegue(withIdentifier: "pharmacySegue", sender: nil)
    }
    
    func showMapView(controllerType:ControllerType){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BussinessGuideViewController") as! BussinessGuideViewController
        vc.controllerType = controllerType
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
}
