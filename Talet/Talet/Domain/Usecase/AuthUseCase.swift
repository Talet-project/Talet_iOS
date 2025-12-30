//
//  AuthUseCase.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import RxSwift


protocol AuthUseCaseProtocol {
    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity>
    func autoLogin() -> Single<Void>
    func signUp(signUpToken: String, request: UserEntity) -> Single<LoginResultEntity>
    func logout() -> Single<Void>
    func deleteAccount() -> Single<Void>
}

final class AuthUseCase: AuthUseCaseProtocol {
    
    private let appleService: AppleLoginService
    private let repository: AuthRepositoryProtocol
    private var tokenManager: TokenManagerProtocol
    
    init(appleService: AppleLoginService,
         repository: AuthRepositoryProtocol,
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
    
    func autoLogin() -> Single<Void> {
        return Single.deferred { [weak self] in
            guard let self else {
                return .error(AuthError.noToken)
            }
            
            return self.repository.validateAccessToken()
                .catch { error in                    
                    guard case NetworkError.detailedError(let errorResponse) = error,
                          let code = errorResponse.code else {
                        return .error(error)
                    }
                    
                    switch code {
                    case "AUTH_TOKEN_EXPIRED":
                        return self.repository.refreshAccessToken()
                            .flatMap { self.repository.validateAccessToken() }
                        
                    case "AUTH_TOKEN_INVALID",
                        "AUTH_CLAIM_PARSING_FAILED",
                        "AUTH_UNAUTHORIZED":
                        self.tokenManager.clear()
                        return .error(error)
                        
                    default:
                        return .error(error)
                    }
                }
        }
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
    
    func logout() -> Single<Void> {
        return repository.logout()
            .do(onSuccess: { [weak self] _ in
                self?.tokenManager.clear()
            })
    }
    
    func deleteAccount() -> Single<Void> {
        return repository.deleteAccount()
            .do(onSuccess: { [weak self] _ in
                self?.tokenManager.clear()
            })
    }
}
    
