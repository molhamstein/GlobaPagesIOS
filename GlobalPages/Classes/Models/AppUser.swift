//
//  User.swift
//  BrainSocket Code base
//
//  Created by BrainSocket on 6/12/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

// MARK: Gender types
enum GenderType: String {
    case male = "male"
    case female = "female"
    case allGender = "allGender"
}

enum Status: String {
    case pending = "pending"
    case active = "active"
    case deactivated = "deactivated"
}

// MARK: User login type
enum LoginType: String {
    case vobble = "registration"
    case facebook = "facebook"
    case twitter = "twitter"
    case google = "google"
    case instagram = "instagram"
    /// check current login state (Social - Normal)
    var isSocial:Bool {
        switch self {
        case .vobble:
            return false
        default:
            return true
        }
    }
}

class AppUser: BaseModel, NSCopying {
    
    // MARK: Keys
    private let kUserObjectIdKey = "id"
    private let kUserFirstNameKey = "username"
    private let kUserEmailKey = "email"
    private let kUserProfilePicKey = "imageProfile"
    private let kUserGenderKey = "gender"
    private let kUserBirthdateKey = "birthDate"
    private let kUserLoginTypeKey = "typeLogIn"
    private let kUserStateKey = "status"
    private let kUserTokenKey = "token"
    private let kUserImage = "image"
    private let KPostsKey = "postCategoriesIds"
    
    // MARK: Properties
    public var objectId: String?
    public var userName: String?
    public var email: String?
    public var profilePic: String?
    public var gender: GenderType?
    public var birthdate: Date?
    public var mobileNumber: String?
    public var loginType: LoginType?
    public var status: Status?
    public var token: String?
    public var posts:[String]?
    
    
    public var postsCount:Int?{
        if posts != nil{
            return posts?.count
        }
        return 0
    }
    // MARK: User initializer
    public override init(){
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        objectId = json[kUserObjectIdKey].string
        userName = json[kUserFirstNameKey].string
        email = json[kUserEmailKey].string
        profilePic = json[kUserProfilePicKey].string
        
        if let genderString = json[kUserGenderKey].string {
            gender = GenderType(rawValue: genderString)
        }
        if let birthdateStr = json[kUserBirthdateKey].string {
            birthdate = DateHelper.getDateFromISOString(birthdateStr)
        }
        if let loginTypeString = json[kUserLoginTypeKey].string {
            loginType = LoginType(rawValue: loginTypeString)
        }
        if let accountStatus = json[kUserStateKey].string {
            status = Status(rawValue: accountStatus)
        }
        if let phoneNum = json["phoneNumber"].string {
            mobileNumber = phoneNum
        }
        if let array = json["postCategoriesIds"].array{
            posts = array.map{$0.string!}
        }
        token = json[kUserTokenKey].string
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // object id
        if let value = objectId {
            dictionary[kUserObjectIdKey] = value
        }
        // first name
        if let value = userName {
            dictionary[kUserFirstNameKey] = value
        }
        // email
        if let value = email {
            dictionary[kUserEmailKey] = value
        }
        // profile picture
        if let value = profilePic {
            dictionary[kUserProfilePicKey] = value
        }
        // gender
        if let value = gender?.rawValue {
            dictionary[kUserGenderKey] = value
        }
        // birthdate
        if let value = mobileNumber {
            dictionary["phoneNumber"] = value
        }
        // login type
        if let value = loginType?.rawValue {
            dictionary[kUserLoginTypeKey] = value
        }
        // account type
        if let value = status?.rawValue {
            dictionary[kUserStateKey] = value
        }
        // token
        if let value = token {
            dictionary[kUserTokenKey] = value
        }
        
        return dictionary
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = AppUser()
        copy.objectId = objectId
        copy.userName = userName
        copy.email = email
        copy.profilePic = profilePic
        copy.gender = gender
        copy.birthdate = birthdate
        copy.loginType = loginType
        copy.status = status
        copy.token = token
        copy.mobileNumber = mobileNumber
        return copy
    }
    
}
