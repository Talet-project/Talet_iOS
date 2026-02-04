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
    var tokenManager: TokenManagerProtocol = TokenManager.shared
    
    init(appleService: AppleLoginService,
         repository: AuthRepositoryProtocol
    ) {
        self.appleService = appleService
        self.repository = repository
    }
    
    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity> {
        let socialTokenSingle: Single<SocialTokenEntity>
        
        switch platform {
        case .apple:
            socialTokenSingle = appleService.authorize().asSingle()
        default:
            return Single.error(NetworkError.invalidRequest)
        }
        
        return socialTokenSingle
            .flatMap { [weak self] token -> Single<LoginResultEntity> in
                guard let self else { return .never() }
                return self.repository.socialLogin(socialToken: token)
            }
            .do(onSuccess: { [weak self] result in
                guard let self,
                      result.isSignUpNeeded == false,
                      let accessToken = result.accessToken,
                      let refreshToken = result.refreshToken
                else { return }
                
                self.tokenManager.accessToken = accessToken
                self.tokenManager.refreshToken = refreshToken
                
            })
    }
    
    func autoLogin() -> Single<Void> {
        return repository.validateAccessToken()
            .catch { _ in
                self.repository.refreshToken()
                    .do(onSuccess: { [weak self] token in
                        self?.tokenManager.accessToken = token.accessToken
                        self?.tokenManager.refreshToken = token.refreshToken
                    })
                    .map { _ in () }
            }
    }
    
    func signUp(
        signUpToken: String,
        request: UserEntity) -> Single<LoginResultEntity> {
            return repository
                .signUp(SignUpString: signUpToken, request: request)
                .do(onSuccess: { [weak self] result in
                    guard let self,
                          let accessToken = result.accessToken,
                          let refreshToken = result.refreshToken
                    else { return }
                    
                    self.tokenManager.accessToken = accessToken
                    self.tokenManager.refreshToken = refreshToken
                })
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
    
