//
//  businessCategories.swift
//  GlobalPages
//
//  Created by Nour  on 8/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import SwiftyJSON

public class categoriesFilter: BaseModel {
    // MARK: Keys
    private let kCategoryName: String = "name"
    private let kCategoryTitleAr: String = "titleAr"
    private let kCategoryTitleEn: String = "titleEn"
    private let kCategoryDate: String = "creationDate"
    private let kCategoryID: String = "id"
    private let kCategoryParent: String = "parentCategoryId"
    private let klocationsKey: String = "locations"
    private let KcityIdKey:String = "cityId"
    // MARK: Properties
    
    public var titleAr:String?
    public var titleEn:String?
    public var nameAr:String?
    public var nameEn:String?
    public var creationDate:String?
    public var Fid:String?
    public var parentCategoryId:String?
    public var locations:[categoriesFilter] = []
    public var cityId:String?
    
    public var filtervalue:filterValues?
    
    public var title:String?{
        
        if AppConfig.currentLanguage == .arabic{
            return titleAr
        }
        if AppConfig.currentLanguage == .english{
            return titleEn
        }
        return titleAr
    }
    

    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        if let value = json["nameAr"].string {
            nameAr = value
            titleAr = value
        }
        if let value = json["nameEn"].string {
            nameEn = value
            titleEn = value
        }
        
        if let value = json[kCategoryTitleAr].string {
            titleAr = value
        }
        
        if let value = json[kCategoryTitleEn].string {
            titleEn = value
        }
        
        if let value = json[kCategoryDate].string {
            creationDate = value
        }
        
        if let value = json[kCategoryID].string {
            Fid = value
        }
        
        if let value = json[kCategoryParent].string {
            parentCategoryId = value
        }
        
        if let array = json[klocationsKey].array {
            print(array)
            locations = array.map{categoriesFilter(json:$0)
                
            }
        }
        if let value = json[KcityIdKey].string{
            cityId = value
        }
    }
    
    override public func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
     
        if let value = nameAr{
            dictionary["nameAr"] = value
        }
        if let value = nameEn{
            dictionary["nameEn"] = value
        }
        if let value = titleAr {
            dictionary[kCategoryTitleAr] = value
        }
        if let value = titleEn {
            dictionary[kCategoryTitleEn] = value
        }
        if let value = creationDate {
            dictionary[kCategoryDate] = value
        }
        if let value = Fid {
            dictionary[kCategoryID] = value
        }
        if let value = parentCategoryId {
            dictionary[kCategoryParent] = value
        }
        
        dictionary[klocationsKey] = locations.map{$0.dictionaryRepresentation()}
        
        if let value = cityId {
            dictionary[KcityIdKey] = value
        }
        return dictionary
    }
}

