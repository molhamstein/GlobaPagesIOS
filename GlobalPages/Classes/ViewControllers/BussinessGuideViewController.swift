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
    
    
    
    var controllerType:ControllerType = .bussinessGuide
    
    var bussinessGuideListCellId = "BussinessGuidListCell"
    static var filtterCellId = "filtterCell"
    var filters:[categoriesFilter] = []
    
    
     //  <wpt lat="33.523644063907177326200326206162571907" lon="36.294101366357040205912198871374130249">
    
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var lat  = 33.5236
    var long = 36.2941
    var lat1 = 33.5536
    var long1 = 36.3011
    var isListView:Bool = false{
        
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

        if controllerType == .nearBy{
            controllerType.showFilters()
            
        }
    }
    
    
    func customizeMap(){
  
        mapView.delegate = self
        // my location Settings
        mapView.showsUserLocation = true
        NotificationCenter.default.addObserver(self, selector: #selector(setMyLocation), name: .notificationLocationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(show3NearBy), name: .notificationShow3NearByChanged, object: nil)
        
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
        
    }
    
    
    override func buildUp() {
        super.buildUp()
        getFilters()
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
        
        self.showNavBackButton = true
    }

    
    func getFilters(){
        filters.removeAll()
        if let city = Filter.bussinesGuid.city{
            filters.append(city)
            if let area = Filter.bussinesGuid.area{
                filters.append(area)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل المدن"
            cat.titleEn = "all cities"
            filters.append(cat)
        }
        
        if let cat = Filter.bussinesGuid.category{
            filters.append(cat)
            if let subCat = Filter.bussinesGuid.subCategory{
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
    
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
    }
    
    
    func switchToMapViewMode(){
        bussinessGuideCollectionView.animateIn(mode: .animateOutToLeft, delay: 0.2)
        bussinessGuideCollectionView.isHidden = true
        overLayView.isHidden = true
    }
    
    
    func setMyLocation(){
        let location = CLLocation(latitude: LocationHelper.shared.myLocation.lat!, longitude: LocationHelper.shared.myLocation.long!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        self.mapView.setRegion(viewRegion, animated: true)
        show3NearBy()
    }
    
    
    // add pin to the mapView
    func centerMapOnLocation(location: CLLocation) {
        self.view.endEditing(true)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        setAnnotaion(location: location)
    }
    func setAnnotaion(location:CLLocation){
      //  mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.mapView.addAnnotation(annotation)
    }
    
    // show 3 nearby in nearby mode
    func show3NearBy(){
        let loc1 = CLLocation(latitude: LocationHelper.shared.myLocation.lat! - 0.01 ,longitude: LocationHelper.shared.myLocation.long! - 0.01)
        setAnnotaion(location: loc1)
        let loc2 = CLLocation(latitude: LocationHelper.shared.myLocation.lat! + 0.01 ,longitude: LocationHelper.shared.myLocation.long! - 0.01)
        setAnnotaion(location: loc2)
        let loc3 = CLLocation(latitude: LocationHelper.shared.myLocation.lat! - 0.01 ,longitude: LocationHelper.shared.myLocation.long! + 0.01)
        setAnnotaion(location: loc3)
    }
    
    
     // show filters
    
    @IBAction func search(_ sender: UIButton) {
        controllerType.showFilters()
    }
    
}

extension BussinessGuideViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView ==  bussinessGuideCollectionView{
            return 10
        }
        if collectionView == filtterCollectionView {
            return filters.count
        }
        return 0
    }
    
    // load collecton view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  bussinessGuideCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bussinessGuideListCellId, for: indexPath) as! BussinessGuidListCell
//            cell.businessGuide = businessGuides[indexPath.item]
//            cell.setpView(colors:self.gradiantColors[indexPath.item])
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
        
        if collectionView == self.filtterCollectionView{
            controllerType.showFilters()
        }
        
        if collectionView == self.bussinessGuideCollectionView {
            self.performSegue(withIdentifier: "BussinessGuidSegue", sender: nil)
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
            return CGSize(width: filters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
        }
        
        
        return CGSize(width: self.view.frame.width * 0.7, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == bussinessGuideCollectionView{
            return 16

        }
        if collectionView == filtterCollectionView{
            return 8
            
        }
      
        return 0
    }

}

// filter cell Delegate
extension BussinessGuideViewController:filterCellProtocol{
    func removeFilter(filter: categoriesFilter) {
        filter.filtervalue?.removeFilter(fltr: Filter.bussinesGuid)
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
        self.bottomView.isHidden = false
        self.bottomView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.tag == 1 {
            return
        }
        view.image = UIImage(named : "pin_black")
        self.bottomView.animateIn(mode: .animateOutToBottom, delay: 0.2)
        self.bottomView.isHidden = true
    }

    
}



class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}
