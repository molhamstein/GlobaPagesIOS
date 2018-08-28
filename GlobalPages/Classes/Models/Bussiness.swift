/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import SwiftyJSON
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

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
	public var cover : String?
	public var lat : String?
	public var long : String?
	public var owner : Owner?
	public var category : Category?
	public var subCategory : Category?

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
            openingDays = array.map{$0.int ?? -1}
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
        
        if let array = json["covers"].array {
            covers = array.map{$0.string ?? ""}
        }
        if let value = json["cover"].string {
            cover = value
        }
       
        if let value = json["lat"].string {
            lat = value
        }
        if let value = json["long"].string {
            long = value
        }
        
//        if let value = json["owner"].string {
//            owner = value
//        }
//        if let value = json["category"].string {
//            category = value
//        }
//
//        if let value = json["subCategory"].string {
//            subCategory = value
//        }
//
  
    }
    

    override public func dictionaryRepresentation() -> [String:Any] {

        var dictionary = super.dictionaryRepresentation()
    
		dictionary["nameEn"] = nameEn
		dictionary["nameAr"] = nameAr
		dictionary["logo"] = logo
		dictionary["status"] = status
        dictionary["openingDays"] = openingDays
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
		dictionary["owner"] = owner
		dictionary["category"] = category
		dictionary["subCategory"] = subCategory
        
		return dictionary
	}

}
