//
//  businessCategories.swift
//  GlobalPages
//
//  Created by Nour  on 8/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import SwiftyJSON

class categoriesFilter: BaseModel {
    // MARK: Keys
    private let kCategoryName: String = "name"
    private let kCategoryTitleAr: String = "titleAr"
    private let kCategoryTitleEn: String = "titleEn"
    private let kCategoryDate: String = "creationDate"
    private let kCategoryID: String = "id"
    private let kCategoryParent: String = "parentCategoryId"
    // MARK: Properties
    public var name:String?
    public var titleAr:String?
    public var titleEn:String?
    public var creationDate:String?
    public var Fid:String?
    public var parentCategoryId:String?
    
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
    
    required init(json: JSON) {
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
        
    }
    
    override func dictionaryRepresentation() -> [String : Any] {
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
        return dictionary
    }
}

