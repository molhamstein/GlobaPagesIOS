//
//  Category.swift
//  BrainSocket Code base
//
//  Created by Molham Mahmoud on 4/27/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

public class Category: BaseModel {
    // MARK: Keys
    private let kCategoryName: String = "name"
    // MARK: Properties
    public var name: String?
    public var code: String?
    public var titleAr : String?
    public var titleEn : String?
    public var creationDate : String?
    public var parentCategoryId: String?
    public var Fid:String?
    public var subCategories : Array<Category>?
//    public var id : String?

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
        if let value = json["code"].string {
            code = value
        }
        
        if let value = json["titleAr"].string {
            titleAr = value
        }
        if let value = json["titleEn"].string {
            titleEn = value
        }
        if let value = json["creationDate"].string {
            creationDate = value
        }
        if let value = json["parentCategoryId"].string {
            parentCategoryId = value
        }
        if let array = json["subCategories"].array{
            subCategories = array.map{Category(json:$0)}
        }
        if let value = json["id"].string {
            Fid = value
        }
    }
    
    override public func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        if let value = name {
            dictionary[kCategoryName] = value
        }

        if let value = Fid{
            dictionary["id"] = value
        }

        if let value = code {
            dictionary["code"] = value
        }
        
        if let value = titleAr {
            dictionary["titleAr"] = value
        }
        if let value = titleEn {
            dictionary["titleEn"] = value
        }
        if let value = creationDate {
            dictionary["creationDate"] = value
        }
        if let value = parentCategoryId {
            dictionary["parentCategoryId"] = value
        }
        
        if let value = subCategories{
            dictionary["subCategories"] = value.map{$0.dictionaryRepresentation()}
        }
        return dictionary
    }
}
