//
//  Filter.swift
//  GlobalPages
//
//  Created by Nour  on 6/27/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import Foundation



public class filter{
    public static var keyWord:String?
    public static var category:String?
    public static var subCategory:String?
    public static var city:String?
    public static var area:String?
    
    
    static func getDictionry()-> [String:Any]{
        
        var parameters:[String:Any] = [:]
        
        parameters["city"] = city
        parameters["category"] = category
        parameters["keyWord"] = keyWord
        parameters["area"] = area
        parameters["subCategory"] = subCategory
        print(parameters)
        return parameters
    }
    
    
    static func clear(){
        self.keyWord = nil
        self.category = nil
        self.city = nil
        self.subCategory = nil
        self.area = nil
    }
    
   public static var selectedCategory:String{
        if let value = filter.subCategory{
            return value
        }else if let value = filter.category{
            return value
        }else {
            return "all Ads"
        }
    }
    
    public static var selectedCity:String{
        if let value = filter.area{
            return value
        }else if let value = filter.city{
            return value
        }else {
            return "all Cities"
        }
        
    }
    
    
    public static func clearCategory(){
        filter.category = nil
        filter.subCategory = nil
    }
    
    
    public static func clearCity(){
        filter.city = nil
        filter.area = nil
    }
    
    
}
