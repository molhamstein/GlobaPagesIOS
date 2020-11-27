//
//  ViewController.swift
//  GlobalPages
//
//  Created by Molham mahmoud on 6/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class HomeViewController: AbstractController {

    // nav bar view
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBarLogo: UIButton!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    @IBOutlet weak var notificationButton: SSBadgeButton!
    @IBOutlet weak var profileButton: SSBadgeButton!
    @IBOutlet weak var messagesButton: SSBadgeButton!
    @IBOutlet weak var orderButton: SSBadgeButton!
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
    @IBOutlet weak var businessGuidView: UIView?
    @IBOutlet weak var businessGuidCollectionView: UICollectionView?
    weak var volumeTitle:UILabel?
    static var businessGuidCellId = "BusinessGuidCell"
    @IBOutlet weak var logoImageView: UIImageView!

    // botom navigation bar
    @IBOutlet weak var nearbyBarItem: UITabBarItem!
    @IBOutlet weak var bottomTabBar: UITabBar!
    
    
    
    var businessGuides:[BusinessGuide] = []
    
    var gradiantColors:[[UIColor]] = [[AppColors.blueLight,AppColors.blueDark],[AppColors.pinkLight,AppColors.pinkDark],[AppColors.blueLight,AppColors.blueDark]]
    

    static var filtterCellId = "filtterCell"
    
    
    var categoryfiltertype:categoryFilterType = .Home
    var marketCategoryfiltertype:categoryFilterType = .HomeMarketProducts
    
    var filters:[categoriesFilter] = []
    var marketFilters:[categoriesFilter] = []
    

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
    var products: [MarketProduct] {
        if DataStore.shared.marketProducts.count > 0{
            var temp = DataStore.shared.marketProducts
            if let keyword = marketCategoryfiltertype.filter.keyWord , !keyword.isEmpty{
                temp = temp.filter({($0.title?.lowercased().contains(find: keyword.lowercased()))!})
            }
            if let city = marketCategoryfiltertype.filter.city{
                temp = temp.filter({$0.city?.Fid == city.Fid})
            }
            if let area = marketCategoryfiltertype.filter.area{
                temp = temp.filter({$0.location?.Fid == area.Fid})
            }
            if let cat = marketCategoryfiltertype.filter.category{
                temp = temp.filter({$0.category?.Fid == cat.Fid})
            }
            if let subCat = marketCategoryfiltertype.filter.subCategory{
                temp = temp.filter({$0.subCategory?.Fid == subCat.Fid})
            }
            
            return temp
        }
        return []
    }
    var shouldLoadMoreProducts: Bool = true
    var currentVolume:Int?{
        didSet{
            getVolume()
        }
    }
    var maxVolumeCount:Int = 20
    
    var pagingTimer = Timer()
    var pagingCurrentIndex = 0
    var pagingCellSize: CGFloat = 0
    
    var profileImageView = UIImageView()
    
    var isMarketProducts: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationButton.badge = nil
        DataStore.shared.marketProducts = []
        LocationHelper.shared.startUpdateLocation()
        self.bottomTabBar.delegate = self
        
        
      
    }

    override func customizeView() {
        let image = "logoWhite_\(AppConfig.currentLanguage.langCode)"
        logoImageView.image = UIImage(named:image)

        collectionViewSetup()
        checkForAppStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchUser()
        getNotifications()
    }

    func changeUserProfileIamge(){
        if let user = DataStore.shared.me{
            if let image = user.profilePic{
                profileImageView.setImageWithCompilietion(image) { (success, error, result) in
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
        self.messagesButton.dropShortShadow()
        self.orderButton.dropShortShadow()
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navbarCustomization()
    }
    
    @objc func applyGradiant(){
        // set gradiant
        self.headerView.applyGradient(colours: [AppColors.yellowDark,AppColors.yellowLight], direction: .diagonal)
        
    }
    
    func collectionViewSetup(){
        
        // adds Collection view layout
        let layout = CustomLayout()
        layout.delegate = self
        adsCollectionView.collectionViewLayout = layout
    
        setupCollectionViewLayout()
        adsCollectionView.dataSource = self
        adsCollectionView.delegate = self
        //self.currentVolume = 0
        
        self.businessGuidCollectionView?.showsVerticalScrollIndicator = false
        self.businessGuidCollectionView?.showsHorizontalScrollIndicator = false
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
    
    func getMarketFilters(){
        marketFilters.removeAll()
        if let keyWord = marketCategoryfiltertype.filter.keyWord{
            let cat = categoriesFilter()
            cat.filtervalue = .keyword
            cat.titleAr = keyWord
            cat.titleEn = keyWord
            marketFilters.append(cat)
        }
        if let city = marketCategoryfiltertype.filter.city{
            marketFilters.append(city)
            if let area = marketCategoryfiltertype.filter.area{
                marketFilters.append(area)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل المدن"
            cat.titleEn = "all cities"
            marketFilters.append(cat)
        }
        
        if let cat = marketCategoryfiltertype.filter.category{
            marketFilters.append(cat)
            if let subCat = marketCategoryfiltertype.filter.subCategory{
                marketFilters.append(subCat)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل الاصناف"
            cat.titleEn = "all categories"
            marketFilters.append(cat)
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
                    let count = result.filter({$0.seen == false}).count
                    self.notificationButton.badge = count > 0 ? "\(count)" : nil
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
            
            if DataStore.shared.featuredPosts.count > 0 {
                self.pagingTimer.invalidate()
                self.pagingTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.scrollToNextPost), userInfo: nil, repeats: true)
            }
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
    
    func getMaxVolumesCount(){
        self.showActivityLoader(true)
        ApiManager.shared.getVolumesCount() { (success, error, result) in
            self.showActivityLoader(false)
            if success {
                self.maxVolumeCount = result
            }
        }
    }
    
    func getMarketProducts(){
        self.showActivityLoader(true)
        ApiManager.shared.getMarketProducts(skip: self.products.count, completionBlock: { (success, error, result) in
            
            self.showActivityLoader(false)
            if success {
                
                self.adsCollectionView.reloadData()
                
                if result == nil || result?.count == 0 {
                    self.shouldLoadMoreProducts = false
                }else {
                    self.shouldLoadMoreProducts = true
                }
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        })
    }
    
    func checkForAppStatus() {
        ApiManager.shared.checkAppStatus(completionBlock: {error, appVersion in
            if let error = error {
                
                let alert = UIAlertController(title: "".localized, message: error.type.errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "RETRY".localized, style: .default, handler: {_ in
                    self.checkForAppStatus()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }else {
                if let version = appVersion {
                    if version.status == .inReview {
                        AppConfig.isInReview = true
                    }else {
                        AppConfig.isInReview = false
                    }
                    
                    self.getFeaturedPosts()
                    self.getNotifications()
                    self.fetchUser()
                    self.currentVolume = 0
                    self.getMaxVolumesCount()
                }
            }
        })
    }
    
    @objc func scrollToNextPost(){
        if self.pagingCurrentIndex >= DataStore.shared.featuredPosts.count - 1 {
            self.pagingCurrentIndex = 0
        }else {
            self.pagingCurrentIndex += 1
        }
        businessGuidCollectionView?.scrollToItem(at: IndexPath(row: self.pagingCurrentIndex, section: 0), at: .centeredHorizontally, animated: true)
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
            return isMarketProducts ? marketFilters.count : filters.count
        }
        if collectionView ==  adsCollectionView{
            if self.isMarketProducts {
                return products.count
            }
            return self.posts.count
        }
        return 0
    }
    
    // load collecton view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  adsCollectionView{
            
            if isMarketProducts {
                let marketProduct = self.products[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketProductCell", for: indexPath) as! MarketProductCell
                
                cell.configureCell(marketProduct)
                cell.btnEdit.isHidden = true
                
                return cell
            }else {
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
            
            
        }

        if collectionView ==  businessGuidCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.businessGuidCellId, for: indexPath) as! BusinessGuidCell
            cell.post = DataStore.shared.featuredPosts[indexPath.item]
            //  cell.setpView(colors:self.gradiantColors[indexPath.item])
            return cell
            
        }
        if collectionView == filtterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.filtterCellId, for: indexPath) as! filtterCell
            cell.filter = isMarketProducts ? marketFilters[indexPath.item] : filters[indexPath.item]
            cell.tag = indexPath.item
            cell.delegate = self
            
            cell.layoutIfNeeded()
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
            if isMarketProducts {
                ActionShowFilters.execute(type: .HomeMarketProducts)
            }else {
                ActionShowFilters.execute(type: .Home)
            }
            
        }
        if collectionView == adsCollectionView {
            if isMarketProducts {
                let marketProduct = self.products[indexPath.row]
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: MarketProductDetailsViewController.className) as! MarketProductDetailsViewController
                
                vc.marketProduct = marketProduct
                //let nav = UINavigationController(rootViewController: vc)
                self.present(vc, animated: true, completion: nil)
            }else {
                let post = self.posts[indexPath.item]
                ActionShowAdsDescrption.execute(post:post)
            }
            
        }
    }
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: businessGuidCollectionView!.contentOffset, size: (businessGuidCollectionView?.bounds.size)!)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        self.pagingCurrentIndex = businessGuidCollectionView?.indexPathForItem(at: visiblePoint)?.row ?? 0
//
//    }
    
    // MARK:- This block of code is for businessGuidCollectionView paging
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isMarketProducts && shouldLoadMoreProducts {
            let offset:CGFloat = 100
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (bottomEdge + offset >= scrollView.contentSize.height) {
                // Load next batch of products
                self.getMarketProducts()
            }
        }else {
            targetContentOffset.pointee = scrollView.contentOffset
            var factor: CGFloat = 0.5
            if velocity.x < 0 {
                factor = -factor
            }
           let indexPath = IndexPath(row: Int(scrollView.contentOffset.x/pagingCellSize + factor), section: 0)
           if indexPath.row < DataStore.shared.featuredPosts.count && indexPath.row >= 0{
                self.businessGuidCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.pagingCurrentIndex = indexPath.row
            }
        }
        
        
        
    }
}

// setup Cell and header Size

extension HomeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  businessGuidCollectionView{
            self.pagingCellSize = self.view.frame.width - 128
            return CGSize(width: self.view.frame.width - 128, height: self.businessGuidView!.frame.height - 16)
        }
        if collectionView == filtterCollectionView {
            if isMarketProducts {
                return CGSize(width: marketFilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
            }else {
                return CGSize(width: filters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
            }
            
        }
        if collectionView ==  adsCollectionView{
            return CGSize(width: self.view.frame.width * 0.5 - 16, height: getCellContentSize(indexPath: indexPath))
        }
        return CGSize(width: self.view.frame.width * 0.7, height: self.businessGuidView!.frame.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == businessGuidCollectionView{
            return UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 64)
        }else {
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == businessGuidCollectionView {
            return 32
        }else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == businessGuidCollectionView{return 64}
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
        
        self.adsCollectionView.register(UINib(nibName: "MarketProductCell", bundle: nil), forCellWithReuseIdentifier: "MarketProductCell")
        
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
        customLayout.settings.menuSize = CGSize(width: self.view.frame.width, height: isMarketProducts ? 127.5 : 162.5)
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
                topHeaderView.businessGuidCollectionView?.isPagingEnabled = true
                topHeaderView.businessGuidCollectionView?.showsHorizontalScrollIndicator = false
                topHeaderView.customizeCell()
               // topHeaderView.delegate = self
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
                    menuView.dateLabel.layoutIfNeeded()
                    menuView.dateLabel.frame = CGRect(x: 32, y: 0, width: self.view.frame.width - 64, height: 35)
                    //menuView.animateAddButton()
                    
                    menuView.volumeView.isHidden = self.isMarketProducts
                    menuView.contentViewConstraint.constant = self.isMarketProducts ? 127.5 : 162.5
                    menuView.volumeViewConstraint.constant = self.isMarketProducts ? 0 : 35
                    menuView.layoutSubviews()
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
    func newspaperDidPressed() {
        self.isMarketProducts = false
        self.getFilters()
        self.adsCollectionView.reloadData()
        Analytics.logEvent("home_newspaper_pressed", parameters: [:])
    }
    
    func marketDidPressed() {
        self.isMarketProducts = true
        self.getMarketFilters()
        
        self.adsCollectionView.reloadData()
        if self.products.count == 0 {
            self.getMarketProducts()
        }
        Analytics.logEvent("home_market_pressed", parameters: [:])
    }

    func reloadCollectionViewDataWithTeamIndex(_ index: Int) {
    }
    
    func nextVolume() {
        if let value = currentVolume , value > 0 {
            currentVolume = currentVolume! - 1
        }
    }
    
    func preVolume(){
        if let value = currentVolume , value < maxVolumeCount - 1{
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
        
        if isMarketProducts {
            return 200
            
        }else {
            var height:CGFloat = 0
            let post = self.posts[indexPath.item]
            if post.type == .image{
                height += 100 // image heigh
                height += 10 // half of the tag view
                height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.small)) ?? 0 // city label height
                height += 8
                height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.small)) ?? 0 // area label height
                height += 18 // line view + 8 + 8
                height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normalBold)) ?? 0 // title label height
                height += 10
            }
            else{
                height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // title label height
                height += 20 // tag view height
                height += (post.description?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal, numberOfLines: 6)) ?? 0 // description label Height
                height += 18 // line view + 8 + 8
                height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // city label height
                height += 8 // padding
                height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normalBold)) ?? 0 // area label height
                height += 16 // extra

            }
            return height
        }
        
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

extension HomeViewController{
   
    
   
    
    func onJobOffersClicked() {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: JobsViewController.className) as! JobsViewController
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
        Analytics.logEvent("home_jobs_btn_pressed", parameters: [:])
    }
    
    
    func bussinessGuiedeCliked() {
        // self.performSegue(withIdentifier: "bussinessGuideSegue", sender: nil)
        self.showMapView(controllerType: .bussinessGuide)
        Analytics.logEvent("home_guide_btn_pressed", parameters: [:])
        
    }
    
    
    func findNearByClicked() {
        self.showMapView(controllerType: .nearBy)
        //self.performSegue(withIdentifier: "nearBySege", sender: nil)
        Analytics.logEvent("home_nearby_btn_pressed", parameters: [:])
    }
    
    func onDutyPharmacyClicked() {
        self.showMapView(controllerType: .pharmacy)
        //        self.performSegue(withIdentifier: "pharmacySegue", sender: nil)
        Analytics.logEvent("home_pharmacies_btn_pressed", parameters: [:])
    }
    
    func showMapView(controllerType:ControllerType){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BussinessGuideViewController") as! BussinessGuideViewController
        vc.controllerType = controllerType
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
}
extension HomeViewController :  UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //This method will be called when user changes tab.
        if(item.tag == 1) {
                print("Home")
            
        }
            else if(item.tag == 2) {
                bussinessGuiedeCliked()
            }
            else if(item.tag == 3) {
                findNearByClicked()
            }
            else if(item.tag == 4) {
               print(":)")
            }
            else if(item.tag == 5) {
                onJobOffersClicked()
            }
    }
}
