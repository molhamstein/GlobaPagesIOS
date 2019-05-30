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
    @IBOutlet weak var profileButtonView: UIView!
    // date View
    @IBOutlet weak var dateView: UIView!
    
    // filter View
    @IBOutlet weak var fillterView: UIView!
    weak var filtterCollectionView: UICollectionView?
    // Ads View
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    var isFirstTimeToLoad = true
    
    // bussiness guid View
    weak var businessGuidView: UIView?
    weak var businessGuidCollectionView: UICollectionView?
    weak var volumeTitle:UILabel?
    static var businessGuidCellId = "BusinessGuidCell"
    @IBOutlet weak var logoImageView: UIImageView!

    var businessGuides:[BusinessGuide] = []
    
    var gradiantColors:[[UIColor]] = [[AppColors.blueLight,AppColors.blueDark],[AppColors.pinkLight,AppColors.pinkDark],[AppColors.blueLight,AppColors.blueDark]]
    

    static var filtterCellId = "filtterCell"
    
    
    var categoryfiltertype:categoryFilterType = .Home
    
    var filters:[categoriesFilter] = []
    

    static var adsImageCellId = "AdsImageCell"
    static var adsTitledCellId = "AdsTitledCell"

    var posts:[Post] {
        if let res = DataStore.shared.volume?.posts{
            var temp = res
            if let keyword = categoryfiltertype.filter.keyWord , !keyword.isEmpty{
                temp = temp.filter({($0.title?.lowercased().contains(find: keyword.lowercased()))!})
            }
            if let city = categoryfiltertype.filter.city{
                temp = temp.filter({$0.city?.Fid == city.Fid})
            }
            if let area = categoryfiltertype.filter.area{
                temp = temp.filter({$0.location?.Fid == area.Fid})
            }
            if let cat = categoryfiltertype.filter.category{
                temp = temp.filter({$0.category?.Fid == cat.Fid})
            }
            if let subCat = categoryfiltertype.filter.subCategory{
                temp = temp.filter({$0.subCategory?.Fid == subCat.Fid})
            }
            temp = temp.filter({$0.isActiviated})
            return temp
        }
        return []
    }
    
    var currentVolume:Int?{
        didSet{
            getVolume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationButton.badge = nil
    }

    override func customizeView() {
        let image = "logoWhite_\(AppConfig.currentLanguage.langCode)"
        logoImageView.image = UIImage(named:image)
        getFeaturedPosts()
        collectionViewSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }


    func changeUserProfileIamge(){
        if let user = DataStore.shared.me{
            if let image = user.profilePic{
                UIImageView().setImageWithCompilietion(image) { (success, error, result) in
                    if success{
                        self.profileButton.setImage(result, for: .normal)
                    }
                    if error != nil{}
                }
            }
        }
    }

    func fetchUser(){
        if DataStore.shared.isLoggedin{
            ApiManager.shared.getMe { (success, error, user) in
                if success{
                    self.changeUserProfileIamge()
                }
                if error != nil{}
            }
 
        }
    }

    func navbarCustomization(){
        // nav bar customization
        self.notificationButton.makeRounded()
        self.profileButton.makeRounded()
        self.notificationButton.dropShortShadow()
        self.profileButton.dropShortShadow()
        self.profileButtonView.makeRounded()
        self.profileButtonView.dropShortShadow()
        self.profileButton.imageView?.makeRounded()
        self.profileButton.imageView?.clipsToBounds = true
        // setFonts

    }
    
    override func buildUp() {
        if isFirstTimeToLoad {
            self.perform(#selector(applyGradiant), with: nil, afterDelay: 0.1)
            isFirstTimeToLoad = false
        }
        getFilters()
        getNotifications()
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
        adsCollectionView.isPagingEnabled = true
        
        setupCollectionViewLayout()
        adsCollectionView.dataSource = self
        adsCollectionView.delegate = self
        self.currentVolume = 0
    }
    
    func getFilters(){
        filters.removeAll()
        if let keyWord = categoryfiltertype.filter.keyWord{
            let cat = categoriesFilter()
            cat.filtervalue = .keyword
            cat.titleAr = keyWord
            cat.titleEn = keyWord
            filters.append(cat)
        }
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
            cat.titleAr = "كل الاصناف"
            cat.titleEn = "all categories"
            filters.append(cat)
        }
        filtterCollectionView?.reloadData()
        self.adsCollectionView.collectionViewLayout.invalidateLayout()
        self.adsCollectionView.reloadData()
        
    }
    
    func getNotifications(){
        guard let userId = DataStore.shared.me?.objectId else { return }
        ApiManager.shared.getNotification(user_id: userId) { (success, error, result) in
            if success{
                if result.count > 0 {
                    let count = result.filter({$0.seen == 1}).count
                    self.notificationButton.badge = "\(count)"
                }else{
                    self.notificationButton.badge = nil
                }
            }
            if error != nil{}
        }
        
    }
    
    
    func getFeaturedPosts(){
        ApiManager.shared.getPosts { (success, error, result) in
            if success{self.businessGuidCollectionView?.reloadData()}
            if error != nil{ }
        }
    }
    
    func getVolume(){
        self.showActivityLoader(true)
        ApiManager.shared.getVolumes(skip: currentVolume ?? 0) { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                self.adsCollectionView.collectionViewLayout.invalidateLayout()
                self.adsCollectionView.reloadData()
                if let title = DataStore.shared.volume?.title{
                    self.volumeTitle?.text = title
                }
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    @IBAction func profileButtonAction(_ sender: AnyObject) {
        if DataStore.shared.isLoggedin {
            self.performSegue(withIdentifier: "HomeProfileSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "HomeLoginSegue", sender: self)
        }
    }
    //NotificationsViewController
    @IBAction func NotificationButtonAction(_ sender: AnyObject) {
        if DataStore.shared.isLoggedin {
            self.performSegue(withIdentifier: "notificationSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "HomeLoginSegue", sender: self)
        }
    }
    
    // unwind segue
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView ==  businessGuidCollectionView{
            return DataStore.shared.featuredPosts.count
        }
        if collectionView == filtterCollectionView {
            return filters.count
        }
        if collectionView ==  adsCollectionView{
            return self.posts.count
        }
        return 0
    }
    
    // load collecton view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  adsCollectionView{
            let post = self.posts[indexPath.item]
            if post.type == .image{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsImageCellId, for: indexPath) as! AdsImageCell
                cell.post = post
                cell.resizeTagView()
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsTitledCellId, for: indexPath) as! AdsTitledCell
                cell.post = post
                cell.resizeTagView()
                return cell
            }
            
        }

        if collectionView ==  businessGuidCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.businessGuidCellId, for: indexPath) as! BusinessGuidCell
            cell.post = DataStore.shared.featuredPosts[indexPath.item]
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
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == businessGuidCollectionView {
            let post = DataStore.shared.featuredPosts[indexPath.item]
            ActionShowAdsDescrption.execute(post:post)
        }
        
        if collectionView == filtterCollectionView {
            ActionShowFilters.execute(type: .Home)
        }
        if collectionView == adsCollectionView {
            let post = self.posts[indexPath.item]
            ActionShowAdsDescrption.execute(post:post)
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

        // adds Collection view Cells
        let nib2 = UINib(nibName: HomeViewController.adsImageCellId, bundle: nil)
        self.adsCollectionView.register(nib2, forCellWithReuseIdentifier: HomeViewController.adsImageCellId)
        
        let nib3 = UINib(nibName: HomeViewController.adsTitledCellId, bundle: nil)
        self.adsCollectionView.register(nib3, forCellWithReuseIdentifier: HomeViewController.adsTitledCellId)
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
                topHeaderView.businessGuidCollectionView?.delegate  = self
                topHeaderView.businessGuidCollectionView?.dataSource = self
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
                    menuView.filtterCollectionView?.delegate = self
                    menuView.filtterCollectionView?.dataSource = self
                    self.volumeTitle = menuView.dateLabel
                    menuView.animateAddButton()
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
    
    func nextVolume() {
        if let value = currentVolume , value > 0 {
            currentVolume = currentVolume! - 1
        }
    }
    
    func preVolume(){
        if let value = currentVolume , value < 4{
            currentVolume = currentVolume! + 1
        }else{
            self.showMessage(message: "END_OF_VOULUMES".localized, type: .warning)
        }
    }
    
    func showMap() {
        
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
        let post = self.posts[indexPath.item]
        
        if post.type == .image{
            height += 100 // image heigh
            height += 10 // half of the tag view
            height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // city label height
            height += 8
            height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // area label height
            height += 18 // line view + 8 + 8
            height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normalBold)) ?? 0 // title label height
            height += 16
        }
        else{
            height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // title label height
            height += 20 // tag view height
            height += (post.description?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // description label Height
            height += 18 // line view + 8 + 8
            height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // city label height
            height += 8 // padding
            height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normalBold)) ?? 0 // area label height
            height += 16 // extra

        }
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
