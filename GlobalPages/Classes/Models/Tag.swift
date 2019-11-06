//
//  Tag.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/22/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Tag: BaseModel {
    
    
    // MARK: Keys
    private let kName: String = "name"
    private let kId: String = "id"
    
    // MARK: Properties
    public var name : String?
    public var idString : String?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        name = json[kName].string
        idString = json[kId].string
        
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        
        if let value = name {
            dictionary[kName] = value
        }
        if let value = idString {
            dictionary[kId] = value
        }

        
        return dictionary
    }
    
}

