//
//  BussinessGuideViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/21/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import MapKit



enum ControllerType{
    
    case bussinessGuide
    case nearBy
    case pharmacy
    
    var title:String{
        switch self {
        case .bussinessGuide:
            return "BUSSINESS_GUIDE_TITLE".localized
        case .nearBy:
            return "NEAR_BY_TITLE".localized
        case .pharmacy:
            return "ON_DUTY_PHARMACY_TITLE".localized
        }
    }
    
    var filterBarViewIsHidden:Bool {
        switch self {
        case .bussinessGuide:
            return false
        case .nearBy:
            return true
        case .pharmacy:
            return true
        }
    }
    
    func showFilters(){
        switch self {
        case .bussinessGuide:
            ActionShowFilters.execute(type: .Category)
        case .nearBy:
            ActionShowNearByFilters.execute()
        default:
            return
        }
    }
    
    func bussiness()->[Bussiness]{
        switch self {
        case .bussinessGuide:
            return DataStore.shared.bussiness
        case .nearBy:
            return DataStore.shared.bussiness
        case .pharmacy:
            return DataStore.shared.bussiness
        }
        
    }
    
}


class BussinessGuideViewController: AbstractController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var filtersBarView: UIView!
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    @IBOutlet weak var bussinessGuideCollectionView: UICollectionView!
    @IBOutlet weak var listMapViewButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var overLayView: UIView!
    @IBOutlet weak var bussinessGuidImageView: UIImageView!
    @IBOutlet weak var bussinessGuideTitleLabel: UILabel!
    @IBOutlet weak var bussinessGuideCategoryLabel: UILabel!
    @IBOutlet weak var goToButton: UIButton!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // nearby filter
    @IBOutlet weak var nearByView: UIView!
    @IBOutlet weak var infoLabel: XUILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var subCategoryTitleLabel: UILabel!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    
    var categoryfiltertype:categoryFilterType = .Category
    var filtterCellId2 = "filterCell2"
    
    var selectedCategory:categoriesFilter?
    var selectedSubCategory:categoriesFilter?
    
    var categoryfilters:[categoriesFilter]{
        return filters.filter{$0.parentCategoryId == nil}
    }
    
    var subCategoryFilters:[categoriesFilter]{
        if let cat = selectedCategory{
            return filters.filter({$0.parentCategoryId == cat.Fid})
        }
        return []
    }
    //
    
    var controllerType:ControllerType = .bussinessGuide
    var selectedBussiness:Bussiness?
    
    var bussinessGuideListCellId = "BussinessGuidListCell"
    static var filtterCellId = "filtterCell"
    var filters:[categoriesFilter] = []
    
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    // filters values
    var filterKeyWord: String?
    var filterCityId: String?
    var filterAreaId: String?
    var filterCatId: String?
    var filterSubCatId: String?
    
    var pageLimit = 100
    // page
    var currentPage:Int = 0 {
        didSet {
            if controllerType == .bussinessGuide {
                
                getBussiness(lat: lat, lng: long, radius: self.mapView.currentRadius())
            }
        }
    }
    
    var lat = 0.0
    var long = 0.0
    var isFirstTime:Bool = true // this is for the cache issue
    
    var isListView:Bool = false {
        didSet{
            if isListView{
                switchToListMode()
            }else{
                switchToMapViewMode()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeMap()
        lat = LocationHelper.shared.myLocation?.lat ?? DefaultLocation.latitude
        long = LocationHelper.shared.myLocation?.long ?? DefaultLocation.longitude
        
        // inizilaze page
        DataStore.shared.bussiness = []
        
        loadData()
    }
    
    override func buildUp() {
        super.buildUp()
        getFilters()
    }
    
    func loadData() {
        if controllerType == .nearBy {
            getBussinessFilters()
            showNearbyFilterView()
        } else if controllerType == .bussinessGuide {
            isListView = true
            isFirstTime = true
            setMyLocation()
            getBussinessFilters()
        } else if controllerType == .pharmacy {
            getNearByPharmacies()
        }
    }
    
    
    func getBussinessFilters() {
        self.showActivityLoader(true)
        ApiManager.shared.businessCategories { (success, error, result ,cats) in
            self.showActivityLoader(false)
            if success {
                self.filters = result
                self.categoryCollectionView.reloadData()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    func showNearbyFilterView(){
        self.nearByView.isHidden = false
        self.nearByView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        self.categoryView.animateIn(mode: .animateInFromRight, delay: 0.4)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if subCategoryView.isHidden == false{
            self.showCategory()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showSubCategory(){
        //      self.categoryView.animateIn(mode: .animateOutToLeft, delay: 0.2)
        subCategoryCollectionView.reloadData()
        dispatch_main_after(0.2) {
            self.subCategoryView.isHidden = false
            self.subCategoryView.animateIn(mode: .animateInFromRight, delay: 0.2)
            self.categoryView.isHidden = true
        }
    }
    
    func showCategory(){
        //   self.subCategoryView.animateIn(mode: .animateOutToRight, delay: 0.2)
        dispatch_main_after(0.2) {
            self.categoryView.isHidden = false
            self.categoryView.animateIn(mode: .animateInFromLeft, delay: 0.2)
            self.subCategoryView.isHidden = true
        }
    }
    
    //
    func customizeMap(){
        mapView.delegate = self
        // my location Settings
        mapView.showsUserLocation = true
        NotificationCenter.default.addObserver(self, selector: #selector(setMyLocation), name: .notificationLocationChanged, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(show3NearBy), name: .notificationShow3NearByChanged, object: nil)
        LocationHelper.shared.startUpdateLocation()
    }
    
    override func customizeView() {
        super.customizeView()
        self.setNavBarTitle(title: controllerType.title)
        bussinessGuideCollectionView.backgroundColor = .clear
        bussinessGuideCollectionView?.register(UINib(nibName: bussinessGuideListCellId, bundle: nil), forCellWithReuseIdentifier: bussinessGuideListCellId)
        let headerNib = UINib(nibName: HomeViewController.filtterCellId, bundle: nil)
        filtterCollectionView.register(headerNib, forCellWithReuseIdentifier: HomeViewController.filtterCellId)
        
        // fonts
        self.tagLabel.font = AppFonts.smallBold
        self.bussinessGuideTitleLabel.font = AppFonts.normal
        self.bussinessGuideCategoryLabel.font = AppFonts.small
        // color
        self.bussinessGuideCategoryLabel.textColor = .black
        self.bussinessGuideCategoryLabel.textColor = AppColors.grayLight
        self.bottomView.isHidden = true
        // set view by controller type
        self.filtersBarView.isHidden = controllerType.filterBarViewIsHidden
        
        
        // near by view
        self.infoLabel.font = AppFonts.big
        self.categoryTitleLabel.font = AppFonts.big
        self.subCategoryTitleLabel.font = AppFonts.big
        
        let nib = UINib(nibName: filtterCellId2, bundle: nil)
        self.categoryCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId2)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId2)
        
        Filter.bussinesGuid.clear();
    }
    
  
    
    override func viewDidLayoutSubviews() {
        // filter bar shadow
        self.filtersBarView.dropShadow()
        self.bottomView.dropShadow()
        self.tagView.dropShadow()
        //corner raduice
        self.filtersBarView.layer.cornerRadius = 5
        self.bottomView.layer.cornerRadius = 5
        self.tagView.layer.cornerRadius = 12
        // gradiant
        self.tagView.applyGradient(colours: [AppColors.yellowDark,AppColors.yellowLight], direction: .diagonal)
        self.showNavBlackBackButton = true
    }
    
    func getBussiness(lat:Double? = nil,lng:Double? = nil,radius:Double? = nil){
        self.showActivityLoader(true)
        
        // if any filter optiosn is selected then dont limit the search geographically, dont sent the raius or the coords
        var searchLat = lat
        var searchLng = lng
        var searchRadius = radius
        if listMapViewButton.isSelected {
            if let _ = Filter.bussinesGuid.keyWord {
                searchRadius = nil
                searchLat = nil
                searchLng = nil
            }
            if let _ = Filter.bussinesGuid.city {
                searchRadius = nil
                searchLat = nil
                searchLng = nil
            }
            if let _ = Filter.bussinesGuid.category {
                searchRadius = nil
                searchLat = nil
                searchLng = nil
            }
        }
        
        ApiManager.shared.getBusinesses(keyword:Filter.bussinesGuid.keyWord,catId: Filter.bussinesGuid.category?.Fid,subCatId: Filter.bussinesGuid.subCategory?.Fid, page:currentPage, locationId: Filter.bussinesGuid.area?.Fid, cityId: Filter.bussinesGuid.city?.Fid,lat: searchLat,lng: searchLng,radius: searchRadius,pageLimit: pageLimit) { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                if (self.isListView){
                    if self.isFirstTime {
                        self.isFirstTime = false
                        DataStore.shared.bussiness =  result
                    }else{
                        DataStore.shared.bussiness.append(contentsOf:result)
                    }
                }else{
                    DataStore.shared.bussiness =  result
                }
                self.setBussinessOnMap()
                self.bussinessGuideCollectionView.reloadData()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    
    func getBussinessOnMaps(lat:Double,lng:Double,radius:Double){
        self.showActivityLoader(true)
        
        ApiManager.shared.getBusinessesOnMap(lat: lat, lng: lng, radius: radius, completionBlock:  { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                DataStore.shared.bussiness =  result
                self.setBussinessOnMap()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        })
    }
    
    func getFilters(){
        if !DataStore.shared.didChangedFilters && !isFirstTime {
            return
        }
        DataStore.shared.didChangedFilters = false
        
        filters.removeAll()
        if let keyWord = Filter.bussinesGuid.keyWord {
            let cat = categoriesFilter()
            cat.filtervalue = .keyword
            cat.titleAr = keyWord
            cat.titleEn = keyWord
            filters.append(cat)
        }
        if let city = Filter.bussinesGuid.city{
            city.filtervalue = .city
            filters.append(city)
            if let area = Filter.bussinesGuid.area{
                area.filtervalue = .area
                filters.append(area)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل المدن"
            cat.titleEn = "All Cities"
            cat.Fid = nil
            filters.append(cat)
        }
        
        if let cat = Filter.bussinesGuid.category{
            cat.filtervalue = .category
            filters.append(cat)
            if let subCat = Filter.bussinesGuid.subCategory{
                subCat.filtervalue = .subCategory
                filters.append(subCat)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل الفئات"
            cat.titleEn = "All Categories"
            cat.Fid = nil
            filters.append(cat)
        }
        isFirstTime = true
        filtterCollectionView?.reloadData()
        currentPage = 0
    }
    
    
    override func backButtonAction(_ sender: AnyObject) {
        if controllerType == .nearBy{
            backAction(self)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // change map View to list view
    @IBAction func changeViewMode(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isListView = sender.isSelected
    }
    
    func switchToListMode(){
        bottomView.animateIn(mode: .animateOutToBottom, delay: 0.2)
        bottomView.isHidden = true
        overLayView.isHidden = false
        bussinessGuideCollectionView.isHidden = false
        bussinessGuideCollectionView.animateIn(mode: .animateInFromLeft, delay: 0.3)
        listMapViewButton.isSelected = true
    }
    
    
    // setBottom View Data
    func setBottomViewWith(bussiness:Bussiness){
        self.bussinessGuidImageView.image = nil
        if let image = bussiness.cover{bussinessGuidImageView.setImageForURL(image, placeholder: nil)}
        if let title = bussiness.title{ bussinessGuideTitleLabel.text = title}
        if let category = bussiness.description{ bussinessGuideCategoryLabel.text = category}
        if let tag = bussiness.category?.title {
            tagLabel.text = tag
            
        }
        
    }
    
    
    // show filters
    
    @IBAction func search(_ sender: UIButton) {
        controllerType.showFilters()
    }
    
    func getNearByBusness(){
        guard let catId = selectedCategory?.Fid, let subCatId = selectedSubCategory?.Fid , let lat = LocationHelper.shared.myLocation?.lat , let lng = LocationHelper.shared.myLocation?.long else{ return}
        self.showActivityLoader(true)
        ApiManager.shared.getNearByBusinesses(lat: "\(lat)", lng: "\(lng)", catId: catId, subCatId: subCatId,codeSubCat:nil, openDay: nil,limit: "100") { (success, error, resutl) in
            
            self.showActivityLoader(false)
            if success{
                self.nearByView.animateIn(mode: .animateOutToBottom, delay: 0.2)
                self.setBussinessOnMap()
            }
            if error != nil{
                if let msg = error?.errorName {
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    func getNearByPharmacies(){
        guard  let lat = LocationHelper.shared.myLocation?.lat , let lng = LocationHelper.shared.myLocation?.long else{ return}
        self.showActivityLoader(true)
        //print(DateHelper.getDayNumberFrom(date: Date()))
        ApiManager.shared.getNearByBusinesses(lat: "\(lat)", lng: "\(lng)", catId: nil, subCatId: nil,codeSubCat:"pharmacies", openDay: "\(DateHelper.getDayNumberFrom(date: Date()))",limit: nil) { (success, error, resutl) in
            
            self.showActivityLoader(false)
            if success{
                
                self.setBussinessOnMap()
            }
            if error != nil{
                if let msg = error?.errorName {
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    @IBAction func goToBussinessDescription(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BussinessDescriptionViewController") as! BussinessDescriptionViewController
        vc.bussiness = selectedBussiness
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension BussinessGuideViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  bussinessGuideCollectionView{return controllerType.bussiness().count}
        if collectionView == filtterCollectionView {return filters.count}
        if collectionView == categoryCollectionView {return categoryfilters.count}
        if collectionView == subCategoryCollectionView {return subCategoryFilters.count}
        return 0
    }
    
    // load collecton view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  bussinessGuideCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bussinessGuideListCellId, for: indexPath) as! BussinessGuidListCell
            cell.bussiness = controllerType.bussiness()[indexPath.item]
            return cell
            
        }
        if collectionView == filtterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.filtterCellId, for: indexPath) as! filtterCell
            cell.filter = filters[indexPath.item]
            cell.tag = indexPath.item
            cell.delegate = self
            return cell
            
        }
        
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filtterCellId2, for: indexPath) as! filterCell2
            if let category = categoryfiltertype.filter.category{
                if category.Fid == categoryfilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.filter = categoryfilters[indexPath.item]
            cell.setupView(type:.map)
            return cell
        }
        
        
        if collectionView == subCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filtterCellId2, for: indexPath) as! filterCell2
            
            if let category = categoryfiltertype.filter.category{
                if category.Fid == subCategoryFilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.filter = subCategoryFilters[indexPath.item]
            cell.setupView(type:.map)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.filtterCollectionView{
            controllerType.showFilters()
        }
        
        if collectionView == self.bussinessGuideCollectionView {
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BussinessDescriptionViewController") as! BussinessDescriptionViewController
            vc.bussiness = self.controllerType.bussiness()[indexPath.item]
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        if collectionView == categoryCollectionView {
            
            if controllerType == .bussinessGuide{
                Filter.bussinesGuid.category = categoryfilters[indexPath.item]
                self.getFilters()
                self.nearByView.animateIn(mode: .animateOutToBottom, delay: 0.3)
                self.nearByView.isHidden = true
            }else if controllerType == .nearBy{
                self.selectedCategory = categoryfilters[indexPath.item]
                self.showSubCategory()
            }
        }
        if collectionView == subCategoryCollectionView{
            ///
            
            self.selectedSubCategory = self.subCategoryFilters[indexPath.item]
            self.getNearByBusness()
        }
    }
}

// setup Cell and header Size

extension BussinessGuideViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  bussinessGuideCollectionView{
            return CGSize(width: self.bussinessGuideCollectionView.bounds.width, height: 72)
        }
        if collectionView == filtterCollectionView {
            return CGSize(width: filters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: 30)
        }
        if collectionView == categoryCollectionView {
            return CGSize(width: categoryfilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: 30)
        }
        
        if collectionView == subCategoryCollectionView{
            return CGSize(width: subCategoryFilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: 30)
            
        }
        
        return CGSize(width: self.view.frame.width * 0.7, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == bussinessGuideCollectionView{
            return 16
        }
        if collectionView == categoryCollectionView {
           return 8
        }
        if collectionView == subCategoryCollectionView{
            return 8
        }
        return 8
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if controllerType == .bussinessGuide{
            let offset:CGFloat = 100
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (bottomEdge + offset >= scrollView.contentSize.height) {
                // Load next batch of products
                currentPage = currentPage +  pageLimit
            }
        }
    }
}

// filter cell Delegate
extension BussinessGuideViewController:filterCellProtocol{
    func removeFilter(filter: categoriesFilter) {
        filter.filtervalue?.removeFilter(fltr: Filter.bussinesGuid)
        DataStore.shared.didChangedFilters = true
        getFilters()
    }
    
}


// map kit delegate
extension BussinessGuideViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "my_pin")
            annotationView?.canShowCallout = false
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
            annotationView?.tag = 1
            return annotationView
        }else{
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(named: "pin_black")
                annotationView?.canShowCallout = false
                let detailButton = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = detailButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.tag == 1 {
            return
        }
        view.image = UIImage(named : "pin_yellow")
        if let title = view.annotation?.title, let tag = Int(title!){
            selectedBussiness = controllerType.bussiness()[tag]
            self.bottomView.isHidden = false
            self.setBottomViewWith(bussiness: selectedBussiness!)
            self.bottomView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.tag == 1 {
            return
        }
        view.image = UIImage(named : "pin_black")
        self.bottomView.animateIn(mode: .animateOutToBottom, delay: 0.2)
        self.bottomView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if controllerType == .bussinessGuide {
            if isListView {return}
            let centralLocationCoordinate = mapView.centerCoordinate
            let radius = self.mapView.currentRadius()
            lat = centralLocationCoordinate.latitude
            long = centralLocationCoordinate.longitude
            currentPage = 0
        }
    }
    
}

// maps function
extension BussinessGuideViewController{
    func switchToMapViewMode(){
        bussinessGuideCollectionView.animateIn(mode: .animateOutToLeft, delay: 0.2)
        bussinessGuideCollectionView.isHidden = true
        overLayView.isHidden = true
        listMapViewButton.isSelected = false
        
//        getBussiness(lat: LocationHelper.shared.myLocation?.lat ?? DefaultLocation.latitude, lng: LocationHelper.shared.myLocation?.long ?? DefaultLocation.longitude, radius: self.mapView.currentRadius())
    }
    
    @objc func setMyLocation(){
        let location = CLLocation(latitude: (LocationHelper.shared.myLocation?.lat) ?? DefaultLocation.latitude, longitude: (LocationHelper.shared.myLocation?.long) ?? DefaultLocation.longitude)
        let regionRadius: CLLocationDistance = 12000
        let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        self.mapView.setRegion(viewRegion, animated: true)
        
        if controllerType == .pharmacy {
            getNearByPharmacies()
        }
    }
    
    
    // add pin to the mapView
    func centerMapOnLocation(location: CLLocation) {
        self.view.endEditing(true)
        let regionRadius: CLLocationDistance = 12000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        setAnnotaion(location: location,tag: -1)
    }
    
    func setAnnotaion(location:CLLocation,tag:Int){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.title = "\(tag)"
        self.mapView.addAnnotation(annotation)
    }
    
    func setBussinessOnMap(){
        mapView.removeAnnotations(mapView.annotations)
        var i = 0
        for bussines in controllerType.bussiness(){
            if let lat = bussines.lat,let long = bussines.long {
                let loc1 = CLLocation(latitude: lat ,longitude: long)
                setAnnotaion(location: loc1,tag: i)
                i += 1
            }
        }
    }
    
    
}

class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}
