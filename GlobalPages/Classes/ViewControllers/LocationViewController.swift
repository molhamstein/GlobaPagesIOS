//
//  LocationViewController.swift
//  Wardah
//
//  Created by Nour  on 12/23/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit
import MapKit

import Alamofire
import SwiftyJSON


class LocationViewController: AbstractController {

    //@IBOutlet weak var searchTextField: XUITextField!
    
    
    @IBOutlet weak var myLocationButton: XUIButton!
    @IBOutlet weak var setLocationButton: XUIButton!

    @IBOutlet weak var resultView: UIView!
    
    var selectedLocation:Location?
    
    
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locateMyLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locateMyLocation), name: .notificationLocationChanged, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.applyStyleGredeant()
        self.setLocationButton.applyStyleGredeant()
    }

    
    override func customizeView() {
        super.customizeView()
        mapView.delegate = self
        
        self.showNavBackButton = true
        self.setNavBarTitle(title: "LOCATION_TITLE".localized)
        
        myLocationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16)
        
        myLocationButton.setTitleColor(AppColors.grayXDark, for: .normal)
        
      //  searchTextField.borderStyle = .none
        
        setLocationButton.isEnabled = false
       // setLocationButton.backgroundColor  = AppColors.grayLight
        
        
        // map action on selectionm
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
      //  searchTextField.delegate = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    
    
    
    @IBAction func handleAutoComplete(_ sender: XUITextField) {
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // map kit methods
    
    
    
    // add annotion by clicling 
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        centerMapOnLocation(location: loc)
        
//        // Add annotation:
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        mapView.addAnnotation(annotation)
    }
    
    
    
     // got to coordinate
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        self.view.endEditing(true)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        selectedLocation = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        mapView.setRegion(coordinateRegion, animated: true)
        setAnnotaion(location: location)
        setLocationButton.isEnabled = true
        setLocationButton.backgroundColor = AppColors.primary
    }

    
    func setAnnotaion(location:CLLocation){
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func setMyLocation(_ sender: XUIButton) {
      locateMyLocation()
    }
    
    @objc func locateMyLocation(){
        LocationHelper.shared.startUpdateLocation()
        if let myLocation = LocationHelper.shared.myLocation {
            let location = CLLocation(latitude: myLocation.lat!, longitude: myLocation.long!)
            centerMapOnLocation(location: location)
            
        }
        
    }
    
    
    @IBAction func setCurrentLocation(_ sender: XUIButton) {
        
//        geocoder.reverseGeocodeLocation(selectedLocation!) { (placemarks, error) in
//            // Process Response
//            self.processResponse(withPlacemarks: placemarks, error: error)
//        }
//        
        // Update View
        
        self.showActivityLoader(true)
        if let location = selectedLocation{
            
            location.getAddressFromCordinates(onDone: { (title, city) in
                self.showActivityLoader(false)
                self.selectedLocation?.address = title
                self.selectedLocation?.city = city
                
                DataStore.shared.location = self.selectedLocation!
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .notificationLocationChanged, object: nil, userInfo: nil)
            })
          
        }
    }

    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        self.showActivityLoader(false)
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                //print(placemark.name)
                //print(placemark.country)
                if let locationName = placemark.addressDictionary!["Name"] as? NSString {
                    //print(locationName)
                }
                
                // Street address
//                if let street = placemark.addressDictionary!["Thoroughfare"] as? NSString {
//                    print(street)
//                }
                
            } else {
                print("No Matching Addresses Found")
            }
        }
    }

    
}


extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "pin")
            
            // if you want a disclosure button, you'd might do something like:
            //
            // let detailButton = UIButton(type: .detailDisclosure)
            // annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
}



extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}

