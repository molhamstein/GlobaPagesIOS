//
//  Applicant.swift
//  GlobalPages
//
//  Created by Abd Hayek on 11/4/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Applicant: BaseModel {
    // MARK: Keys
    private let kUser: String = "user"
    private let kStatus: String = "status"
    private let kCreationDate: String = "createdAt"

    // MARK: Properties
    public var user: AppUser?
    public var status: String?
    public var createdAt: String?
  
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        if let value = json[kStatus].string {
            status = value
        }
        
        if let value = json[kCreationDate].string {
            createdAt = value
        }

        if json[kUser] != JSON.null {
            user = AppUser(json: json[kUser])
        }
        
    }
    
    override public func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        if let value = status {
            dictionary[kStatus] = value
        }
        
        if let value = createdAt {
            dictionary[kCreationDate] = value
        }
        
        if let value = user {
            dictionary[kUser] = value.dictionaryRepresentation()
        }

        return dictionary
    }
}

enum ApplicantStatus : String, CaseIterable {
    case pending = "pending"
    case interviewing = "interviewing"
    case noHire = "noHire"
    case hire = "hire"
    
    
    var title: String {
        switch self {
        case .pending:
            return "APPLICANT_PENDING".localized
        case .interviewing:
            return "APPLICANT_INTERVIEWING".localized
        case .noHire:
            return "APPLICANT_NO_HIRE".localized
        case .hire:
            return "APPLICANT_HIRE".localized

        }
    }
    
}
