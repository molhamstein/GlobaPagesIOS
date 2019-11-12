//
//  businessCategories.swift
//  GlobalPages
//
//  Created by Nour  on 8/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import SwiftyJSON

public class City: BaseModel {
    // MARK: Keys
    private let kCategoryName: String = "name"
    private let kCategoryTitleAr: String = "nameAr"
    private let kCategoryTitleEn: String = "nameEn"
    private let kCategoryDate: String = "creationDate"
    private let kCategoryID: String = "id"
    private let kCategoryParent: String = "parentCategoryId"
    private let KLocationsKey:String = "locations"
    // MARK: Properties
    public var name:String?
    public var titleAr:String?
    public var titleEn:String?
    public var creationDate:String?
    public var Fid:String?
    public var parentCategoryId:String?
    public var locations:[City]?
    
    public var filtervalue:filterValues?
    
    public var title:String?{
        return AppConfig.currentLanguage == .arabic ? titleAr : titleEn
    }
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        if let value = json[kCategoryName].string {
            name = value
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
        
        if let array = json[KLocationsKey].array{
            locations = array.map{City(json:$0)}
        }
        
    }
    
    override public func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        if let value = name {
            dictionary[kCategoryName] = value
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
        
        if let array = locations{
            dictionary[KLocationsKey] = array.map{$0.dictionaryRepresentation()}
        }
        return dictionary
    }
}


