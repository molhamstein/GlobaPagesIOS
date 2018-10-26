//
//  Notification.swift
//  GlobalPages
//
//  Created by Nour  on 10/26/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import Foundation

import SwiftyJSON

public class AppNotification: BaseModel {
    
    
    // MARK: Keys
    private let kType: String = "_type"
    private let kseen: String = "seen"
    private let kid: String = "id"
    private let Kmessage: String = "message"
    private let KrecipientId: String = "recipientId"

    // MARK: Properties
    public var message : String?
    public var type : String?
    public var seen: Bool?
    public var Nid: String?
    public var recipientId :String?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        message = json[Kmessage].string
        Nid = json["id"].string
        type = json[kType].string
        seen = json[kseen].bool
        recipientId = json[KrecipientId].string
        
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        
        if let value = seen {
            dictionary[kseen] = value
        }
        if let value = message {
            dictionary[Kmessage] = value
        }
        if let value = type {
            dictionary[kType] = value
        }
        dictionary["id"] = Nid
        dictionary[KrecipientId] = recipientId
        
        return dictionary
    }
    
}
