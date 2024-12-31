//
//  APIKeys.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/3/24.
//

import Foundation

enum APIKeys {
    static let baseURL = "https://cheongha.site/api/v1"
    static let youthCenterBaseURL = "www.youthcenter.go.kr"
    static let youthCenterAPIKey = "8209a6c285cde4d07010e0dd"
    
    static let noImageURL = "https://k-rope.com/theme/boilerplate/img/noimage.png"
    
    static func getRegionCode(with region: String) -> String {
        switch region {
        case "중앙부처":
            return "003001004"
        case "서울":
            return "003002001"
        case "부산":
            return "003002002"
        case "대구":
            return "003002003"
        case "인천":
            return "003002004"
        case "광주":
            return "003002005"
        case "대전":
            return "003002006"
        case "울산":
            return "003002007"
        case "경기":
            return "003002008"
        case "강원":
            return "003002009"
        case "충북":
            return "003002010"
        case "충남":
            return "003002011"
        case "전북":
            return "003002012"
        case "전남":
            return "003002013"
        case "경북":
            return "003002014"
        case "경남":
            return "003002015"
        case "제주":
            return "003002016"
        case "세종":
            return "003002017"
        default:
            return ""
        }
    }
    
    static func getPolicyCode(with policy: String) -> String {
        switch policy {
        case "일자리":
            return "023010"
        case "주거":
            return "023020"
        case "교육":
            return "023030"
        case "복지,문화":
            return "023040"
        case "참여,권리":
            return "023050"
        default:
            return ""
        }
    }
}
