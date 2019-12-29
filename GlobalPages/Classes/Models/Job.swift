//
//  Job.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/29/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Job: BaseModel {
    
    
    // MARK: Keys
    private let kjobId: String = "id"
    private let knameEn: String = "nameEn"
    private let knameAr: String = "nameAr"
    private let kbusiness: String = "business"
    private let kbusinessId: String = "businessId"
    private let kcategory: String = "category"
    private let kcategoryId: String = "categoryId"
    private let kcreationDate: String = "creationDate"
    private let kdescriptionAr: String = "descriptionAr"
    private let kdescriptionEn: String = "descriptionEn"
    private let krangeSalary: String = "rangeSalary"
    private let kstatus: String = "status"
    private let ksubCategory: String = "subCategory"
    private let ksubCategoryId: String = "subCategoryId"
    private let kresponsibilitiesAr: String = "responsibilitiesAr"
    private let kresponsibilitiesEn: String = "responsibilitiesEn"
    private let kqualificationsAr: String = "qualificationsAr"
    private let kqualificationsEn: String = "qualificationsEn"
    private let kminimumEducationLevel: String = "minimumEducationLevel"
    private let kjobType: String = "jobType"
    private let ktag: String = "tags"
    private let kisApplied: String = "userIsApplied"
    private let kownerId: String = "ownerId"
    private let kNumberOfApplicants = "NumberOfApplicants"

    // MARK: Properties
    public var jobId : String?
    public var nameEn : String?
    public var nameAr : String?
    public var business : Bussiness?
    public var businessId : String?
    public var category : Category?
    public var categoryId : String?
    public var creationDate : String?
    public var descriptionAr : String?
    public var descriptionEn : String?
    public var rangeSalary : String?
    public var status : String?
    public var subCategory : Category?
    public var subCategoryId : String?
    public var responsibilitiesAr: String?
    public var responsibilitiesEn: String?
    public var qualificationsAr: String?
    public var qualificationsEn: String?
    public var educationLevel: String?
    public var jobType: String?
    public var tags: [Tag]?
    public var isApplied: Bool?
    public var ownerId: String?
    public var numberOfApplicants: Int?
    
    public var name: String? {
        if AppConfig.currentLanguage == .arabic {
            if nameAr != nil && nameAr != "" {
                return nameAr
            }else {
                return nameEn
            }
        }else {
            if nameEn != nil && nameEn != "" {
                return nameEn
            }else {
                return nameAr
            }
        }
    }
    
    public var description: String? {
        if AppConfig.currentLanguage == .arabic {
            if descriptionAr != nil && descriptionAr != "" {
                return descriptionAr
            }else {
                return descriptionEn
            }
        }else {
            if descriptionEn != nil && descriptionEn != "" {
                return descriptionEn
            }else {
                return descriptionAr
            }
        }
    }
    
    public var qualificationsTitle: String? {
        if AppConfig.currentLanguage == .arabic {
            if qualificationsAr != nil && qualificationsAr != "" {
                return qualificationsAr
            }else {
                return qualificationsEn
            }
        }else {
            if qualificationsEn != nil && qualificationsEn != "" {
                return qualificationsEn
            }else {
                return qualificationsAr
            }
        }

    }
    
    public var responsibilitiesTitle: String? {
        if AppConfig.currentLanguage == .arabic {
            if responsibilitiesAr != nil && responsibilitiesAr != "" {
                return responsibilitiesAr
            }else {
                return responsibilitiesEn
            }
        }else {
            if responsibilitiesEn != nil && responsibilitiesEn != "" {
                return responsibilitiesEn
            }else {
                return responsibilitiesAr
            }
        }
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        jobId = json[kjobId].string
        nameEn = json[knameEn].string
        nameAr = json[knameAr].string
        businessId = json[kbusinessId].string
        categoryId = json[kcategoryId].string
        creationDate = json[kcreationDate].string
        descriptionAr = json[kdescriptionAr].string
        descriptionEn = json[kdescriptionEn].string
        rangeSalary = json[krangeSalary].string
        status = json[kstatus].string
        subCategoryId = json[ksubCategoryId].string
        responsibilitiesAr = json[kresponsibilitiesAr].string
        responsibilitiesEn = json[kresponsibilitiesEn].string
        qualificationsAr = json[kqualificationsAr].string
        qualificationsEn = json[kqualificationsEn].string
        educationLevel = json[kminimumEducationLevel].string
        jobType = json[kjobType].string
        isApplied = json[kisApplied].bool
        ownerId = json[kownerId].string
        numberOfApplicants = json[kNumberOfApplicants].int
        
        if let array = json[ktag].array { tags = array.map{Tag(json:$0)} }
        
        if json[kbusiness] != JSON.null {
            business = Bussiness(json: json[kbusiness])
        }
        
        if json[kcategory] != JSON.null {
            category = Category(json: json[kcategory])
        }
        
        if json[ksubCategory] != JSON.null {
            subCategory = Category(json: json[ksubCategory])
        }
        
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        
        if let value = jobId {
            dictionary[kjobId] = value
        }
        if let value = nameEn {
            dictionary[knameEn] = value
        }
        if let value = nameAr {
            dictionary[knameAr] = value
        }
        if let value = business {
            dictionary[kbusiness] = value.dictionaryRepresentation()
        }
        if let value = businessId {
            dictionary[kbusinessId] = value
        }
        if let value = category {
            dictionary[kcategory] = value.dictionaryRepresentation()
        }
        if let value = categoryId {
            dictionary[kcategoryId] = value
        }
        if let value = creationDate {
            dictionary[kcreationDate] = value
        }
        if let value = descriptionAr {
            dictionary[kdescriptionAr] = value
        }
        if let value = descriptionEn {
            dictionary[kdescriptionEn] = value
        }
        if let value = rangeSalary {
            dictionary[krangeSalary] = value
        }
        if let value = status {
            dictionary[kstatus] = value
        }
        if let value = subCategory {
            dictionary[ksubCategory] = value.dictionaryRepresentation()
        }
        if let value = subCategoryId {
            dictionary[ksubCategoryId] = value
        }
        if let value = responsibilitiesAr {
            dictionary[kresponsibilitiesAr] = value
        }
        if let value = responsibilitiesEn {
            dictionary[kresponsibilitiesEn] = value
        }
        if let value = qualificationsAr {
            dictionary[kqualificationsAr] = value
        }
        if let value = qualificationsEn {
            dictionary[kqualificationsEn] = value
        }
        if let value = educationLevel {
            dictionary[kminimumEducationLevel] = value
        }
        if let value = jobType {
            dictionary[kjobType] = value
        }
        if let value = tags {
            dictionary[ktag] = value
        }
        if let value = isApplied {
            dictionary[kisApplied] = value
        }
        
        if (tags?.count ?? 0) > 0 { dictionary[ktag] = tags?.map{$0.dictionaryRepresentation()} }
        
        return dictionary
    }
    
}

enum JobType : String, CaseIterable{
    case partTime = "partTime"
    case fullTime = "fullTime"
    case projectBased = "projectBased"
    case volunteer = "volunteer"
    case internship = "internship"
    
    var title: String {
        switch self {
        case .partTime:
            return "PART_TIME".localized
        case .fullTime:
            return "FULL_TIME".localized
        case .projectBased:
            return "PROJECT_BASE".localized
        case .volunteer:
            return "VOLUNTEER".localized
        case .internship:
            return "INTERNSHIP".localized
        }
    }
    
}

enum EducationLevel : String, CaseIterable {
    case highSchoolDegree = "highSchoolDegree"
    case associateDegree = "associateDegree"
    case universityDegree = "universityDegree"
    case masterDegree = "masterDegree"
    case doctoralDegree = "doctoralDegree"
    
    var title: String {
        switch self {
        case .highSchoolDegree:
            return "HIGH_SCHOOL_DEGREE".localized
        case .associateDegree:
            return "ASSOCIATE_DEGREE".localized
        case .universityDegree:
            return "UNIVERSITY_DEGREE".localized
        case .masterDegree:
            return "MASTER_DEGREE".localized
        case .doctoralDegree:
            return "DOCTORAL_DEGREE".localized
        }
    }

}


