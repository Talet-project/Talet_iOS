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
    private let repository: LoginRepositoryProtocol
    private var tokenManager: TokenManagerProtocol
    
    init(appleService: AppleLoginService,
         repository: LoginRepositoryProtocol,
         tokenManager: TokenManagerProtocol = TokenManager.shared
    ) {
        self.appleService = appleService
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity> {
        
        //MARK: 각 로그인 후 SocialToken 반환 (Service)
        let socialTokenSingle: Single<SocialTokenEntity>
        
        switch platform {
        case .apple:
            socialTokenSingle = appleService.authorize().asSingle()
        default:
            return Single.error(NetworkError.invalidRequest)
        }
        
        // MARK: SocialToken을 Single<LoginResultEntity>로 변환 (Repository)
        return socialTokenSingle
            .flatMap { [weak self] token -> Single<LoginResultEntity> in
                guard let self else { return .never() }
                return self.repository.socialLogin(socialToken: token)
            }
            .do(onSuccess: { [weak self] result in
                guard let self else { return }
                
                if result.isSignUpNeeded {
                    return
                }
                
                if let accessToken = result.accessToken {
                    self.tokenManager.accessToken = accessToken
                }
                
                if let refreshToken = result.refreshToken {
                    self.tokenManager.refreshToken = refreshToken
                }
            }
                
            )
    }
}
