//
//  MarketProduct.swift
//  GlobalPages
//
//  Created by Abd Hayek on 12/31/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class MarketProduct: BaseModel {
    var titleEn: String?
    var titleAr: String?
    var descriptionAr: String?
    var descriptionEn: String?
    var ownerID: String?
    var businessID: String?
    var status: String?
    var price: Int?
    var cityID: String?
    var locationID: String?
    var categoryID: String?
    var subCategoryID: String?
    var creationDate: Date?
    var images: [String]?
    var category : Category?
    var subCategory : Category?
    var city: City?
    var location: City?
    var owner : Owner?
    var bussiness : Bussiness?
    var tags: [Tag]?
    
    public var title: String? {
        return AppConfig.currentLanguage == .arabic ? titleAr : titleEn
    }
    
    public var description: String? {
        return AppConfig.currentLanguage == .arabic ? descriptionAr : descriptionEn
    }
    
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        if let value = json["titleEn"].string {titleEn = value}
        if let value = json["titleAr"].string {titleAr = value}
        if let value = json["descriptionAr"].string {descriptionAr = value}
        if let value = json["descriptionEn"].string {descriptionEn = value}
        if let value = json["ownerId"].string {ownerID = value}
        if let value = json["businessId"].string {businessID = value}
        if let value = json["status"].string {status = value}
        if let value = json["price"].int {price = value}
        if let value = json["cityId"].string {cityID = value}
        if let value = json["locationId"].string {locationID = value}
        if let value = json["categoryId"].string {categoryID = value}
        if let value = json["subCategoryId"].string {subCategoryID = value}
        if let strDate = json["creationDate"].string {
            creationDate = DateHelper.getDateFromISOString(strDate)
        }
        if let value = json["media"].array {self.images = value.map({$0.stringValue})}
        if (json["category"] != JSON.null) { category = Category(json: json["category"]) }
        if (json["subCategory"] != JSON.null) { subCategory = Category(json: json["subCategory"]) }
        if json["city"] != JSON.null { city = City(json:json["city"]) }
        if json["location"] != JSON.null { location = City(json:json["location"]) }
        if json["owner"] != JSON.null { owner = Owner(json:json["owner"]) }
        if json["business"] != JSON.null { bussiness = Bussiness(json:json["business"]) }
        if let array = json["tags"].array { tags = array.map{Tag(json:$0)} }
    }
    
    override public func dictionaryRepresentation() -> [String:Any] {
        
        var dictionary = super.dictionaryRepresentation()
        
        dictionary["titleEn"] = titleEn
        dictionary["titleAr"] = titleAr
        dictionary["descriptionAr"] = descriptionAr
        dictionary["descriptionEn"] = descriptionEn
        dictionary["ownerId"] = ownerID
        dictionary["businessId"] = businessID
        dictionary["status"] = status
        dictionary["price"] = price
        dictionary["cityId"] = cityID
        dictionary["locationId"] = locationID
        dictionary["categoryId"] = categoryID
        dictionary["subCategoryId"] = subCategoryID
        dictionary["creationDate"] = self.creationDate != nil ? DateHelper.getStringFromDate(self.creationDate!) : ""
        dictionary["media"] = images
        if let value = city { dictionary["city"] = value.dictionaryRepresentation()}
        if let value = location { dictionary["location"] = value.dictionaryRepresentation()}
        if owner != nil{dictionary["owner"] = self.owner?.dictionaryRepresentation()}
        if category != nil {dictionary["category"] = self.category?.dictionaryRepresentation()}
        if subCategory != nil {dictionary["subCategory"] = self.subCategory?.dictionaryRepresentation()}
        if bussiness != nil {dictionary["business"] = self.bussiness?.dictionaryRepresentation()}
        if let value = tags { dictionary["tags"] = value.map({$0.dictionaryRepresentation()}) }
        
        return dictionary
    }
    
}
