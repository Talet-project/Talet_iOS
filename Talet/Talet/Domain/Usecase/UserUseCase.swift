//
//  UserUseCase.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import RxSwift


protocol UserUseCaseProtocol: AnyObject {
    func fetchUserInfo() -> Single<UserEntity>
}

class UserUseCase: UserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUserInfo() -> RxSwift.Single<UserEntity> {
        return repository.fetchUserInfo()
    }
}
