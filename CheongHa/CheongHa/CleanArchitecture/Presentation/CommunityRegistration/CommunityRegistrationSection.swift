//
//  CommunityRegistrationSection.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/27/24.
//

import Foundation

enum CommunityRegistrationSection: Int, CaseIterable {
    case topic
    case title
    case content
    case selectedImages
}

enum CommunityRegistrationSectionItem: Hashable {
    case topic(data: CommunityRegistrationSectionIDataCollection)
    case title(data: CommunityRegistrationSectionIDataCollection)
    case content(data: CommunityRegistrationSectionIDataCollection)
    case selectedImages(data: CommunityRegistrationSectionIDataCollection)
    
    var data: CommunityRegistrationSectionIDataCollection {
        switch self {
        case .topic(let data):
            return data
        case .title(let data):
            return data
        case .content(let data):
            return data
        case .selectedImages(let data):
            return data
        }
    }
}

struct CommunityRegistrationSectionIDataCollection: Hashable {
    let topicData: String
    let titleData: String
    let contentData: String
    let selectedImagesData: [String]
    
    init(
        topicData: String = "",
        titleData: String = "",
        contentData: String = "",
        selectedImagesData: [String] = []
    ) {
        self.topicData = topicData
        self.titleData = titleData
        self.contentData = contentData
        self.selectedImagesData = selectedImagesData
    }
}
