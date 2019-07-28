/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import SwiftyJSON

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Post:BaseModel{
	public var title : String?
	public var description : String?
	public var status : String?
	public var viewsCount : Int?
	public var creationDate : Date?
	public var ownerId : String?
	public var categoryId : String?
	public var subCategoryId : String?
	public var media : [Media]?
	public var owner : Owner?
	public var category : Category?
	public var subCategory : Category?
    public var categoryFilter : categoriesFilter?
    public var subCategoryFilter : categoriesFilter?
    public var isFeatured: Bool?
    public var city:City?
    public var location:City?
    public var phone1:String?
    public var phone2:String?
    public var fax:String?
    
    public var image : String?{
        return media?.first?.fileUrl
    }

    var isActiviated:Bool{
        if status != nil{
            return status == "activated"
        }
        return false
    }
    
    public var type:AdsType?{
        if self.image == nil{
            return AdsType.titled
        }
        return AdsType.image
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        title = json["title"].string
        description = json["description"].string
        status = json["status"].string
        viewsCount = json["viewsCount"].int
        if let strDate = json["creationDate"].string{
            creationDate = DateHelper.getDateFromISOString(strDate)
        }
        ownerId = json["ownerId"].string
        categoryId = json["categoryId"].string
        subCategoryId = json["subCategoryId"].string
        isFeatured = json["isFeatured"].bool
        if let array = json["media"].array {
            media = array.map{Media(json:$0)}
        }
        if (json["category"] != JSON.null) { category = Category(json: json["category"]) }
        if (json["subCategory"] != JSON.null) { subCategory = Category(json: json["subCategory"]) }
        if (json["category"] != JSON.null) { categoryFilter = categoriesFilter(json: json["category"]) }
        if (json["subCategory"] != JSON.null) { subCategoryFilter = categoriesFilter(json: json["subCategory"]) }
        if json["city"] != JSON.null { city = City(json:json["city"]) }
        if json["location"] != JSON.null { location = City(json:json["location"]) }
        if json["owner"] != JSON.null { owner = Owner(json:json["owner"]) }
    }


    override public func dictionaryRepresentation() -> [String:Any] {

		var dictionary = super.dictionaryRepresentation()

		dictionary["title"] = self.title
		dictionary["description"] = self.description
		dictionary["status"] = self.status
		dictionary["viewsCount"] = self.viewsCount
		dictionary["creationDate"] = self.creationDate
		dictionary["ownerId"] = self.ownerId
		dictionary["categoryId"] = self.categoryId
		dictionary["subCategoryId"] = self.subCategoryId
        dictionary["isFeatured"] = self.isFeatured
        if let value = city { dictionary["city"] = value.dictionaryRepresentation()}
        if let value = location { dictionary["location"] = value.dictionaryRepresentation()}
        if let value = media {dictionary["media"] = value.map{$0.dictionaryRepresentation()} }
        if owner != nil{dictionary["owner"] = self.owner?.dictionaryRepresentation()}
        if category != nil {dictionary["category"] = self.category?.dictionaryRepresentation()}
        if subCategory != nil {dictionary["subCategory"] = self.subCategory?.dictionaryRepresentation()}
		return dictionary
	}

}
