//
//  AuthUseCase.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import RxSwift


protocol AuthUseCaseProtocol {
    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity>
}

final class AuthUseCase: AuthUseCaseProtocol {
    
    private let appleService: AppleLoginService
    // DI: Usecase가 RepositoryProcol을 참조
    private let repository: LoginRepositoryProtocol
    
    init(appleService: AppleLoginService, repository: LoginRepositoryProtocol) {
        self.appleService = appleService
        self.repository = repository
    }
    
    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity> {
        switch platform {
        case .apple:
            return appleService.authorize()
                .flatMap { [weak self] tokenEntity -> Single<LoginResultEntity> in
                    guard let self else { return Single.never() }
                    return self.repository.socialLogin(socialToken: tokenEntity)
                }
                .asSingle()
        default:
            return Single.error(NetworkError.invalidRequest)
        }
    }
}
