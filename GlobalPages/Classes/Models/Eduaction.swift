//
//  Eduaction.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/21/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Education: BaseModel {
    
    
    // MARK: Keys
    private let kTitle: String = "title"
    private let kEducationalEntity: String = "educationalEntity"
    private let kFrom: String = "from"
    private let kTo: String = "to"
    private let kDescription: String = "description"
    
    // MARK: Properties
    public var title : String?
    public var educationalEntity : String?
    public var from: String?
    public var to: String?
    public var description: String?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        title = json[kTitle].string
        educationalEntity = json[kEducationalEntity].string
        from = json[kFrom].string
        to = json[kTo].string
        description = json[kDescription].string
        
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        
        if let value = title {
            dictionary[kTitle] = value
        }
        if let value = educationalEntity {
            dictionary[kEducationalEntity] = value
        }
        if let value = from {
            dictionary[kFrom] = value
        }
        if let value = to {
            dictionary[kTo] = value
        }
        if let value = description {
            dictionary[kDescription] = value
        }
        
        return dictionary
    }
    
}

