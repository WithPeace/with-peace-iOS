//
//  UpdateProfileBody.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/9/24.
//

import Foundation

struct UpdateProfileBody {
    let nickname: String
    let imageFile: ImageFile
    
    enum FieldName {
        static let nickname = "nickname"
        static let imageFile = "imageFile"
    }
}

struct ImageFile {
    let imageData: Data
    let name: String
    let mimeType: MemeType
    
    enum MemeType: String {
        case png = "image/png"
        case jpeg = "image/jpeg"
    }
}
