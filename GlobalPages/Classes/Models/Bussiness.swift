/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import SwiftyJSON
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Points:BaseModel{
    var lat:Double?
    var long:Double?
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        lat = json["lat"].double
        long = json["lng"].double
    }
    
    override public func dictionaryRepresentation() -> [String:Any] {
        var dictionary = super.dictionaryRepresentation()
        dictionary["lat"] = self.lat
        dictionary["lng"] = self.long
        return dictionary
    }
}


public enum Day:Int{
    case saturday = 7
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednsday = 4
    case thursday = 5
    case fridy = 6
    
    var name:String{
        switch self {
        case .saturday:
            return "Saturday".localized
        case .sunday :
            return "Sunday".localized
        case .monday :
            return "Monday".localized
        case .tuesday :
            return "Tuesday".localized
        case .wednsday :
            return "Wednsday".localized
        case .thursday :
            return "Thursday".localized
        case .fridy :
            return "Friday".localized
        }
    }
}

public class Bussiness:BaseModel {
    
	public var nameEn : String?
	public var nameAr : String?
	public var logo : String?
	public var status : String?
	public var description : String?
	public var openingDays : Array<Int>?
	public var openingDaysEnabled : Bool?
	public var ownerId : String?
	public var products : Array<Product>?
	public var categoryId : String?
	public var subCategoryId : String?
	public var cityId : String?
	public var locationId : String?
	public var covers : Array<String>?
	public var owner : Owner?
	public var category : Category?
	public var subCategory : Category?
    public var city : City?
    public var location : City?
    public var locationPoint : Points?
    public var media:[Media]?
    public var phone1:String?
    public var phone2:String?
    public var fax:String?
    public var address:String?

    public var lat : Double?{
        return locationPoint?.lat
    }
    
    public var long : Double?{
        return locationPoint?.long
    }
    
    public var cover : String?{
        return media?.first?.fileUrl
    }

    public var isActive:Bool{
        if status != nil{
            return status == "activated"
        }
        return false
    }
    
    var title:String?{
        if AppConfig.currentLanguage == .arabic{
            return nameAr
        }
        return nameEn
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)

        if let value = json["nameEn"].string {
            nameEn = value
        }
        if let value = json["nameAr"].string {
            nameAr = value
        }
        
        if let value = json["logo"].string {
            logo = value
        }
       
        if let value = json["status"].string {
            status = value
        }
        if let value = json["description"].string {
            description = value
        }
        if let array =  json["openingDays"].array {
            openingDays = array.map{$0.int ?? 0}
        }
        
        if let value = json["openingDaysEnabled"].bool {
            openingDaysEnabled = value
        }
        if let value = json["ownerId"].string {
            ownerId = value
        }
        
        
        if let array = json["products"].array{
            products = array.map{Product(json:$0)}
            
        }
        
        if let value = json["categoryId"].string {
            categoryId = value
        }
        if let value = json["subCategoryId"].string {
            subCategoryId = value
        }
        if let value = json["cityId"].string {
            cityId = value
        }
        
        if let value = json["locationId"].string {
            locationId = value
        }
        
        if let value = json["textAddress"].string{
            address = value
        }
       
//        if let value = json["lat"].string {
//            lat = value
//        }
//        if let value = json["long"].string {
//            long = value
//        }
//
        if json["locationPoint"] != JSON.null {
            locationPoint = Points(json: json["locationPoint"])
        }

//        if json["owner"] != JSON.null {
//            owner = Owner(json:json["owner"])
//        }
        if  json["category"] != JSON.null {
            category = Category(json:json["category"])
        }

        if json["subCategory"] != JSON.null {
            subCategory = Category(json:json["subCategory"])
        }

        if json["city"] != JSON.null{
            city = City(json:json["city"])
        }
        if json["location"] != JSON.null{
            location = City(json:json["location"])
        }
        if let array = json["media"].array{
            media = array.map{Media(json:$0)}
        }
        
        if let value = json["phone1"].string{phone1 = value}
        if let value = json["phone2"].string{phone2 = value}
        if let value = json["fax"].string{fax = value}
  
    }
    

    override public func dictionaryRepresentation() -> [String:Any] {

        var dictionary = super.dictionaryRepresentation()
    
		dictionary["nameEn"] = nameEn
		dictionary["nameAr"] = nameAr
		dictionary["logo"] = logo
		dictionary["status"] = status
        if let value = openingDays {dictionary["openingDays"] = value.map{$0}}
		dictionary["description"] = description
		dictionary["openingDaysEnabled"] = openingDaysEnabled
		dictionary["ownerId"] = ownerId
		dictionary["categoryId"] = categoryId
		dictionary["subCategoryId"] = subCategoryId
		dictionary["cityId"] = cityId
		dictionary["locationId"] = locationId
		dictionary["cover"] = cover
		dictionary["lat"] = lat
		dictionary["long"] = long
        dictionary["phone1"] = phone1
        dictionary["phone2"] = phone2
        dictionary["fax"] = fax
        dictionary["textAddress"] = address
        if let value = owner{dictionary["owner"] = value.dictionaryRepresentation()}
        if let value = category {dictionary["category"] = value.dictionaryRepresentation()}
        if let value = subCategory{dictionary["subCategory"] = value.dictionaryRepresentation()}
        if let value = locationPoint{dictionary["locationPoint"] = value.dictionaryRepresentation()}
        if let value = media {dictionary["media"] = value.map{$0.dictionaryRepresentation()}}
    //    if let value = media {dictionary["covers"] = value.map{$0.dictionaryRepresentation()}}
        if let array = products {dictionary["products"] = array.map{$0.dictionaryRepresentation()}}
        
		return dictionary
	}

}
