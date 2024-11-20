//
//  PolicyClassification.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/20/24.
//

import Foundation

enum PolicyClassification: String, Codable {
    case job = "JOB"
    case resident = "RESIDENT"
    case education = "EDUCATION"
    case welfareAndCulture = "WELFARE_AND_CULTURE"
    case participationAndRight =  "PARTICIPATION_AND_RIGHT"
    case etc = "ETC"
    
    var policyImage: ImageResource {
        switch self {
        case .job:
            return .jobThumbnail
        case .resident:
            return .livingThumbnail
        case .education:
            return .eduThumbnail
        case .welfareAndCulture:
            return .cultureThumbnail
        case .participationAndRight:
            return .participationThumbnail
        case .etc:
            return .eduThumbnail
        }
    }
}
