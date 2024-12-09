//
//  ProfileRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/6/24.
//

import Foundation
import Moya

enum ProfileRouter {
    case fetchProfile
    case updateProfile(body: UpdateProfileBody)
}

extension ProfileRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchProfile, .updateProfile:
            return "/users/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchProfile:
            return .get
        case .updateProfile:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchProfile:
            return .requestPlain
        case .updateProfile(let body):
            let nicknameData = Moya.MultipartFormData(
                provider: .data(body.nickname.data(using: .utf8) ?? Data()),
                name: UpdateProfileBody.FieldName.nickname
            )
            let profileImageData = Moya.MultipartFormData(
                provider: .data(body.imageFile.imageData),
                name: UpdateProfileBody.FieldName.imageFile,
                fileName: body.imageFile.name,
                mimeType: body.imageFile.mimeType.rawValue
            )
            var multipartFormDatas: [Moya.MultipartFormData] = [nicknameData, profileImageData]
            
            return .uploadMultipart(multipartFormDatas)
        }
    }
}
