//
//  UserUseCase.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import Foundation

import RxSwift


protocol UserUseCaseProtocol: AnyObject {
    func fetchUserInfo() -> Single<UserEntity>
    func updateUserInfo(user: UserEntity) -> Single<UserEntity>
    func updateUserImage(image: Data) -> Single<UserEntity>
}

class UserUseCase: UserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUserInfo() -> RxSwift.Single<UserEntity> {
        return repository.fetchUserInfo()
    }
    
    func updateUserInfo(user: UserEntity) -> Single<UserEntity> {
        repository.updateUserInfo(request: user)
    }
    
    func updateUserImage(image: Data) -> Single<UserEntity> {
        repository.updateUserImage(imageData: image)
    }
}
