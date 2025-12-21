//
//  SignUpUseCase.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import RxSwift


protocol SignUpUseCaseProtocol {
    func signUp(
        signUpToken: String,
        request: UserEntity
    ) -> Single<LoginResultEntity>
}

final class SignUpUseCase: SignUpUseCaseProtocol {
    private let repository: SignUpRepositoryProtocol
    private let tokenManager: TokenManager
    
    init(repository: SignUpRepositoryProtocol, tokenManager: TokenManager) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func signUp(
        signUpToken: String,
        request: UserEntity) -> Single<LoginResultEntity> {
            return repository
                .signUp(SignUpString: signUpToken, request: request)
                .flatMap { [weak self] result -> Single<LoginResultEntity> in
                    
                    guard let self else { return .just(result) }
                    if let accessToken = result.accessToken {
                        self.tokenManager.accessToken = accessToken
                    }
                    if let refreshToken = result.refreshToken {
                        self.tokenManager.refreshToken = refreshToken
                    }
                    
                    return .just(result)
                }
        }
}
