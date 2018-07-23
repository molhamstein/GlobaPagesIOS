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
            return false
        case .pharmacy:
            return true
        }
    }
    
    
    func showFilters(){
        
        switch self {
        case .bussinessGuide:
            ActionShowFilters.execute()
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
    var filters:[String] = ["all Cities","all Ads"]
    
    
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
        self.showNavBackButton = true
        
        let CLLCoordType = CLLocationCoordinate2D(latitude: lat,
                                                  longitude: long);
        let anno = MKPointAnnotation();
        anno.coordinate = CLLCoordType;
        mapView.addAnnotation(anno);
        
        let CLLCoordType2 = CLLocationCoordinate2D(latitude: lat1,
                                                  longitude: long1);
        let anno2 = MKPointAnnotation();
        anno2.coordinate = CLLCoordType2;
        mapView.addAnnotation(anno2);
        
        let location = CLLocation(latitude: lat, longitude: long)
        let center = CLLocationCoordinate2D(latitude:location.coordinate.latitude , longitude:location.coordinate.longitude)
        let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        mapView.setRegion(region, animated: true)
        
        setAnnotaion(location: location)
        
        let location2 = CLLocation(latitude: lat1, longitude: long1)
        setAnnotaion(location: location2)

        
        mapView.delegate = self
        
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
    }

    
    func getFilters(){
        
        filters[0] = filter.selectedCity
        filters[1] = filter.selectedCategory
        filtterCollectionView.reloadData()
        
        
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
//        bottomView.animateIn(mode: .animateOutToBottom, delay: 0.2)
//        bottomView.isHidden = true
        bussinessGuideCollectionView.animateIn(mode: .animateOutToLeft, delay: 0.2)
        bussinessGuideCollectionView.isHidden = true
        overLayView.isHidden = true
    }
    
    
    // add pin to the mapView
    func setAnnotaion(location:CLLocation){
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.mapView.addAnnotation(annotation)
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
            cell.title = filters[indexPath.item]
            cell.tag = indexPath.item
            cell.delegate = self
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controllerType.showFilters()
    }
}

// setup Cell and header Size

extension BussinessGuideViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  bussinessGuideCollectionView{
            return CGSize(width: self.bussinessGuideCollectionView.bounds.width, height: 72)
        }
        if collectionView == filtterCollectionView {
            return CGSize(width: filters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
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
    
    func removeFilter(tag:Int) {
        if tag == 1{
            filter.clearCategory()
        }else if tag == 0{
            filter.clearCity()
        }
        getFilters()
    }
    
}


// map kit delegate
extension BussinessGuideViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "MyPin"
            if annotation is MKUserLocation {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    annotationView?.image = UIImage(named: "pin_black")
                    annotationView?.canShowCallout = false
                    // annotationView?.contentMode = .scaleAspectFill
                    
                    // if you want a disclosure button, you'd might do something like:
                    
                    let detailButton = UIButton(type: .detailDisclosure)
                    annotationView?.rightCalloutAccessoryView = detailButton
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
            }

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.image = UIImage(named: "pin_black")
                annotationView?.canShowCallout = false
               // annotationView?.contentMode = .scaleAspectFill

                // if you want a disclosure button, you'd might do something like:
                
                 let detailButton = UIButton(type: .detailDisclosure)
                 annotationView?.rightCalloutAccessoryView = detailButton
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named : "pin_yellow")
        self.bottomView.isHidden = false
        self.bottomView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named : "pin_black")
        self.bottomView.animateIn(mode: .animateOutToBottom, delay: 0.2)
        self.bottomView.isHidden = true
    }
    
    

    
  
    
}



class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}
