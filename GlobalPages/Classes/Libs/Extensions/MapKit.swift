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
    
   
    
    func currentRadius() -> Double {
        let centralLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude:  self.centerCoordinate.longitude)
        let topCentralLat:Double = centerCoordinate.latitude -  self.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centerCoordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 1000.0
    }
    
}
