//
//  PolicyDetailDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/27/24.
//

import Foundation

struct PolicyDetailDTO: DTOType {
    var data: PolicyDetailData?
    var error: Errors?
}

struct PolicyDetailData: Codable {
    /// 정책 id
    let id: String
    /// 정책 제목
    let title: String
    /// 정책 소개
    let introduce: String
    /// 정책 분야
    let classification: PolicyClassification
    /// 지원 내용
    let applicationDetails: String
    /// 연령
    let ageInfo: String
    /// 거주지 및 소득
    let residenceAndIncome: String
    /// 학력
    let education: String
    /// 특화 분야
    let specialization: String
    /// 추가 단서 사항
    let additionalNotes: String
    /// 참여 제한 대상
    let participationRestrictions: String
    /// 신청 절차
    let applicationProcess: String
    /// 심사 및 발표
    let screeningAndAnnouncement: String
    /// 신청 사이트
    let applicationSite: String
    /// 제출 서류
    let submissionDocuments: String
    /// 기타 유익 정보
    let additionalUsefulInformation: String
    /// 주관 기관
    let supervisingAuthority: String
    /// 운영 기관
    let operatingOrganization: String
    /// 사업관련 참고 사이트 1
    let businessRelatedReferenceSite1: String
    /// 사업관련 참고 사이트 2
    let businessRelatedReferenceSite2: String
    /// true: 찜하기O
    let isFavorite: Bool
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.introduce = try container.decode(String.self, forKey: .introduce)
        let classification = try container.decode(String.self, forKey: .classification)
        self.classification = PolicyClassification(rawValue: classification) ?? PolicyClassification.etc
        self.applicationDetails = try container.decode(String.self, forKey: .applicationDetails)
        self.ageInfo = try container.decode(String.self, forKey: .ageInfo)
        self.residenceAndIncome = try container.decode(String.self, forKey: .residenceAndIncome)
        self.education = try container.decode(String.self, forKey: .education)
        self.specialization = try container.decode(String.self, forKey: .specialization)
        self.additionalNotes = try container.decode(String.self, forKey: .additionalNotes)
        self.participationRestrictions = try container.decode(String.self, forKey: .participationRestrictions)
        self.applicationProcess = try container.decode(String.self, forKey: .applicationProcess)
        self.screeningAndAnnouncement = try container.decode(String.self, forKey: .screeningAndAnnouncement)
        self.applicationSite = try container.decode(String.self, forKey: .applicationSite)
        self.submissionDocuments = try container.decode(String.self, forKey: .submissionDocuments)
        self.additionalUsefulInformation = try container.decode(String.self, forKey: .additionalUsefulInformation)
        self.supervisingAuthority = try container.decode(String.self, forKey: .supervisingAuthority)
        self.operatingOrganization = try container.decode(String.self, forKey: .operatingOrganization)
        self.businessRelatedReferenceSite1 = try container.decode(String.self, forKey: .businessRelatedReferenceSite1)
        self.businessRelatedReferenceSite2 = try container.decode(String.self, forKey: .businessRelatedReferenceSite2)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}
