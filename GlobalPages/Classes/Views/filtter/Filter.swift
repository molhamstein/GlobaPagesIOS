//
//  Filter.swift
//  GlobalPages
//
//  Created by Nour  on 6/27/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import Foundation

public enum filterValues {
    case category
    case subCategory
    case city
    case area
    func removeFilter(fltr:Filter){
        switch self{
        case .category:
            fltr.category = nil
            fltr.subCategory = nil
        case .subCategory:
            fltr.subCategory = nil
        case .area:
            fltr.area = nil
        case .city :
            fltr.city = nil
            fltr.area = nil
        }
    }
}

 class Filter{
    public var keyWord:String?
    public var category:categoriesFilter?
    public var subCategory:categoriesFilter?
    public var city:categoriesFilter?
    public var area:categoriesFilter?
    public var value:filterValues?
    
    public static var home = Filter()
    public static var bussinesGuid = Filter()
    
     func getDictionry()-> [String:Any]{
        var parameters:[String:Any] = [:]
        parameters["city"] = city?.title
        parameters["category"] = category?.title
        parameters["keyWord"] = keyWord
        parameters["area"] = area?.title
        parameters["subCategory"] = subCategory?.title
        print(parameters)
        return parameters
    }
    
     func clear(){
        self.keyWord = nil
        self.category = nil
        self.city = nil
        self.subCategory = nil
        self.area = nil
    }
//   public static var selectedCategory:categoriesFilter{
//        if let value = filter.subCategory{
//            return value
//        }else if let value = filter.category{
//            return value
//        }else {
//            return "all Ads"
//        }
//    }
//
//    public static var selectedCity:String{
//        if let value = filter.area{
//            return value
//        }else if let value = filter.city{
//            return value
//        }else {
//            return "all Cities"
//        }
//
//    }
    
    public func clearCategory(){
        self.category = nil
        self.subCategory = nil
    }
    
    public func clearCity(){
        self.city = nil
        self.area = nil
    }

}
