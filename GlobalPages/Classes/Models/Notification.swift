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
    private let KcreationDate: String = "creationDate"
    private let Kdata: String = "data"
    private let KvolumeId: String = "volumeId"

    // MARK: Properties
    public var message : String?
    public var type : String?
    public var seen: Int?
    public var Nid: String?
    public var recipientId :String?
    public var creationDate: String?
    public var data : [String : Any]?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        message = json[Kmessage].string
        Nid = json["id"].string
        type = json[kType].string
        seen = json[kseen].int
        recipientId = json[KrecipientId].string
        creationDate = json[KcreationDate].string
        data = json[Kdata].dictionaryObject
        
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
        if let value = data {
            dictionary[Kdata] = value
        }
        if let value = creationDate {
            dictionary[KcreationDate] = value
        }
        
        dictionary["id"] = Nid
        dictionary[KrecipientId] = recipientId
        
        return dictionary
    }
    
}
