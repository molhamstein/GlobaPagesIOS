//
//  Experience.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/21/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Experience: BaseModel {
    
    
    // MARK: Keys
    private let kTitle: String = "title"
    private let kCompanyName: String = "companyName"
    private let kFrom: String = "from"
    private let kTo: String = "to"
    private let kIsPresent: String = "isPresent"
    private let kDescription: String = "description"
    
    // MARK: Properties
    public var title : String?
    public var companyName : String?
    public var from: String?
    public var to: String?
    public var isPresent: Bool?
    public var description: String?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        title = json[kTitle].string
        companyName = json[kCompanyName].string
        from = json[kFrom].string
        to = json[kTo].string
        isPresent = json[kIsPresent].bool
        description = json[kDescription].string
        
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        
        if let value = title {
            dictionary[kTitle] = value
        }
        if let value = companyName {
            dictionary[kCompanyName] = value
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
        
        if let value = isPresent {
            dictionary[kIsPresent] = value
        }
        
        return dictionary
    }
    
}

