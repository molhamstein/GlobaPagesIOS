//
//  MapKit.swift
//  GlobalPages
//
//  Created by Nour  on 9/18/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    
    

    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation) / 1000
    }
   
//    
//    func currentRadius() -> Double {
//        let centralLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude:  self.centerCoordinate.longitude)
//        let topCentralLat:Double = centerCoordinate.latitude -  self.region.span.latitudeDelta / 2
//        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centerCoordinate.longitude)
//        let radius = centralLocation.distance(from: topCentralLocation)
//        return radius / 1000.0
//    }
    
}
