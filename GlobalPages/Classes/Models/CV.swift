//
//  CV.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/22/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class CV: BaseModel {
    
    
    // MARK: Keys
    private let kBio: String = "bio"
    private let kPrimaryIdentifier: String = "primaryIdentifier"
    private let kEducation: String = "education"
    private let kExperience: String = "experience"
    private let kTag: String = "tags"
    private let kGithub: String = "githubLink"
    private let kBehance: String = "behanceLink"
    private let kTWitter: String = "twitterLink"
    private let kWebsite: String = "websiteLink"
    private let kFacebook: String = "facebookLink"
    private let kURL: String = "cvURL"
    private let kCity: String = "city"
    private let kPhoneNumber: String = "phoneNumber"
    private let kEmail = "email"
    private let kUserProfilePicKey = "imageProfile"
    private let kUserFirstNameKey = "username"
    
    
    // MARK: Properties
    public var education : [Education]?
    public var experience : [Experience]?
    public var tags: [Tag]?
    public var behanceLink : String?
    public var facebookLink : String?
    public var twitterLink : String?
    public var githubLink : String?
    public var websiteLink : String?
    public var phoneNumber : String?
    public var email : String?
    public var bio : String?
    public var primaryIdentifier : String?
    public var cvURL: String?
    public var city: City?
    public var profilePic: String?
    public var userName: String?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        if let array = json[kEducation].array { education = array.map{Education(json:$0)} }
        if let array = json[kExperience].array { experience = array.map{Experience(json:$0)} }
        if let array = json[kTag].array { tags = array.map{Tag(json:$0)} }
        
        if json[kCity] != JSON.null {
            city = City(json: json[kCity])
        }
        
        githubLink = json[kGithub].string
        facebookLink = json[kFacebook].string
        behanceLink = json[kBehance].string
        twitterLink = json[kTWitter].string
        websiteLink = json[kWebsite].string
        bio = json[kBio].string
        primaryIdentifier = json[kPrimaryIdentifier].string
        cvURL = json[kURL].string
        phoneNumber = json[kPhoneNumber].string
        email = json[kEmail].string
        profilePic = json[kUserProfilePicKey].string
        userName = json[kUserFirstNameKey].string
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        
        if let value = behanceLink {
            dictionary[kBehance] = value
        }
        if let value = githubLink {
            dictionary[kGithub] = value
        }
        if let value = twitterLink {
            dictionary[kTWitter] = value
        }
        if let value = facebookLink {
            dictionary[kFacebook] = value
        }
        if let value = websiteLink {
            dictionary[kWebsite] = value
        }
        if let value = bio {
            dictionary[kBio] = value
        }
        if let value = primaryIdentifier {
            dictionary[kPrimaryIdentifier] = value
        }
        if let value = cvURL {
            dictionary[kURL] = value
        }
        if let value = email {
            dictionary[kEmail] = value
        }
        if let value = phoneNumber {
            dictionary[kPhoneNumber] = value
        }
        if let value = city {
            dictionary[kCity] = value.dictionaryRepresentation()
        }
        if let value = profilePic {
            dictionary[kUserProfilePicKey] = value
        }
        if let value = userName {
            dictionary[kUserFirstNameKey] = value
        }
        
        if (education?.count ?? 0) > 0 { dictionary[kEducation] = education?.map{$0.dictionaryRepresentation()} }
        if (experience?.count ?? 0) > 0 { dictionary[kExperience] = experience?.map{$0.dictionaryRepresentation()} }
        if (tags?.count ?? 0) > 0 { dictionary[kTag] = tags?.map{$0.dictionaryRepresentation()} }
        
        
        return dictionary
    }
    
}

