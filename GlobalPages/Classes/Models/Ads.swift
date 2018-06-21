//
//  Ads.swift
//  GlobalPages
//
//  Created by Nour  on 6/18/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import Foundation


enum AdsType{
    
case image
case titled
    
}


struct Ads {
    var title:String
    var image:String
    var info:String
    var tag:String
    var address:String
    var type:AdsType
}
