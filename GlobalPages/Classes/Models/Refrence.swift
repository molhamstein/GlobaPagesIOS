//
//  Refrence.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/22/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import Foundation
import UIKit

struct Refrence {
    let url: String?
    let type: RefrenceType?
}

enum RefrenceType {
    case github
    case behance
    case facebook
    case twitter
    case website
    
    var icon: UIImage? {
        switch self {
        case .github:
            return UIImage(named: "ic_github")
        case .behance:
            return UIImage(named: "ic_behance")
        case .facebook:
            return UIImage(named: "ic_face")
        case .twitter:
            return UIImage(named: "ic_twitter")
        case .website:
            return UIImage(named: "ic_web")
        }
    }
}
