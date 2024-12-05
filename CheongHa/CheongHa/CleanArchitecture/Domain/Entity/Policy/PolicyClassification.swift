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

    var policyName: String {
        switch self {
        case .job:
            return "일자리"
        case .resident:
            return "주거"
        case .education:
            return "교육"
        case .welfareAndCulture:
            return "복지,문화"
        case .participationAndRight:
            return "참여,권리"
        case .etc:
            return ""
        }
    }
}
