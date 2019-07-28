/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import SwiftyJSON
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Owner {
	public var status : String?
	public var birthDate : String?
	public var phoneNumber : String?
	public var gender : String?
	public var creationDate : String?
	public var username : String?
	public var email : String?
	public var id : String?
	public var postCategoriesIds : Array<String>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let owner_list = Owner.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Owner Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Owner]
    {
        var models:[Owner] = []
        for item in array
        {
            models.append(Owner(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let owner = Owner(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Owner Instance.
*/
	required public init?(dictionary: NSDictionary) {

		status = dictionary["status"] as? String
		birthDate = dictionary["birthDate"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
		gender = dictionary["gender"] as? String
		creationDate = dictionary["creationDate"] as? String
		username = dictionary["username"] as? String
		email = dictionary["email"] as? String
		id = dictionary["id"] as? String
//        if (dictionary["postCategoriesIds"] != nil) { postCategoriesIds = PostCategoriesIds.modelsFromDictionaryArray(dictionary["postCategoriesIds"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.birthDate, forKey: "birthDate")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.gender, forKey: "gender")
		dictionary.setValue(self.creationDate, forKey: "creationDate")
		dictionary.setValue(self.username, forKey: "username")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.id, forKey: "id")

		return dictionary
	}

    
    init(json: JSON) {
        self.id = json["id"].string
        username = json["username"].string
        email = json["email"].string
        
        if let genderString = json["gender"].string {
            gender = genderString
        }
        if let birthdateStr = json["birthDate"].string {
            self.birthDate = birthdateStr
        }
        if let accountStatus = json["status"].string {
            status = accountStatus
        }
        if let phoneNum = json["phoneNumber"].string {
            self.phoneNumber = phoneNum
        }
    }
    
}
