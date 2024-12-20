//
//  HomeSection.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/16/24.
//

import Foundation

enum HomeSection: Int, CaseIterable {
    case myKeywords
    case hotPolicy
    case policyRecommendation
    case community
}

enum HomeSectionItem: Hashable {
    case myKeywords(data: HomeSectionItemDataCollection)
    case hotPolicy(data: HomeSectionItemDataCollection)
    case policyRecommendation(data: HomeSectionItemDataCollection)
    case community(data: HomeSectionItemDataCollection)
    
    var data: HomeSectionItemDataCollection {
        switch self {
        case .myKeywords(let data):
            return data
        case .hotPolicy(let data):
            return data
        case .policyRecommendation(let data):
            return data
        case .community(let data):
            return data
        }
    }
}

struct HomeSectionItemDataCollection: Hashable {
    var myKeywordsData: String
    var hotPolicyData: HotPolicyData
    var policyRecommendationData: PolicyRecommendationData
    var communityData: CommunityData
    
    init(
        myKeywordsData: String = "",
        hotPolicyData: HotPolicyData = .init(),
        policyRecommendationData: PolicyRecommendationData = .init(),
        communityData: CommunityData = .init()
    ) {
        self.myKeywordsData = myKeywordsData
        self.hotPolicyData = hotPolicyData
        self.policyRecommendationData = policyRecommendationData
        self.communityData = communityData
    }
    
    struct HotPolicyData: Identifiable, Hashable {
        let id = UUID()
        var thumnail: ImageResource
        var description: String
        
        init(
            thumnail: ImageResource = .eduThumbnail,
            title: String = ""
        ) {
            self.thumnail = thumnail
            self.description = title
        }
    }
    
    struct PolicyRecommendationData: Identifiable, Hashable {
        let id = UUID()
        var thumnail: ImageResource
        var description: String
        
        init(
            thumnail: ImageResource = .eduThumbnail,
            title: String = ""
        ) {
            self.thumnail = thumnail
            self.description = title
        }
    }
    
    struct CommunityData: Identifiable, Hashable {
        let id = UUID()
        var title: String
        var recentPostTitle: String
        
        init(
            title: String = "",
            recentPostTitle: String = ""
        ) {
            self.title = title
            self.recentPostTitle = recentPostTitle
        }
    }
}
