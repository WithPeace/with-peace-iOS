//
//  PostModel.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import Foundation

struct PostModel {
    var uuid = UUID()
    var title: String
    var content: String
    var type: String
    var imageFiles: [Data]
    var creationDate: Date
}
