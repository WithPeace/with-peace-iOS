//
//  ProfileUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation
import RxSwift

protocol ProfileUsecaseProtocol {
    func fetchProfile() -> Single<CleanProfileDTO>
    func updateProfile(body: UpdateProfileBody) -> Single<CleanProfileDTO>
}

final class ProfileUsecase: ProfileUsecaseProtocol {
    
    private let profileRepository: ProfileRepositoryProtocol
    
    init(profileRepository: ProfileRepositoryProtocol ) {
        self.profileRepository = profileRepository
    }
    
    func fetchProfile() -> Single<CleanProfileDTO> {
        return profileRepository.fetchProfile(api: .fetchProfile)
    }
    
    func updateProfile(body: UpdateProfileBody) -> Single<CleanProfileDTO> {
        return profileRepository.updateProfile(api: .updateProfile(body: body))
    }
}
