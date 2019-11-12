


import Foundation
import SwiftyJSON


public class Volume:BaseModel {
	public var titleAr : String?
	public var titleEn : String?
	public var status : String?
	public var creationDate : String?
	public var postsIds : Array<String>?
	public var posts : [Post] = [Post]()

    public var title:String?{
        return AppConfig.currentLanguage == .arabic ? titleAr : titleEn
    }
    
    var isActiviated:Bool{
        if status != nil{
            return status == "activated"
        }
        return false
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        titleAr = json["titleAr"].string
        titleEn = json["titleEn"].string
        status = json["status"].string
        creationDate = json["creationDate"].string
//        if (json["postsIds"] != nil) { postsIds = PostsIds.modelsFromDictionaryArray(dictionary["postsIds"] as! NSArray) }
        if let array = json["posts"].array { posts = array.map{Post(json:$0)} }
    }

   override public func dictionaryRepresentation() -> [String:Any] {
		var dictionary = super.dictionaryRepresentation()

		dictionary["titleAr"] = self.titleAr
		dictionary["titleEn"] = self.titleEn
		dictionary["status"] = self.status
		dictionary["creationDate"] = self.creationDate
        if posts.count > 0{ dictionary["posts"] = posts.map{$0.dictionaryRepresentation()} }
    
		return dictionary
	}
}
