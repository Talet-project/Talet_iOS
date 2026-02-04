//
//  MockAuthRepository.swift
//  TaletTests
//

import RxSwift
@testable import Talet


final class MockAuthRepository: AuthRepositoryProtocol {

    // MARK: - Configurable Results

    var validateResult: Single<Void> = .just(())
    var refreshResult: Single<TokenEntity> = .just(TokenEntity(accessToken: "new_access", refreshToken: "new_refresh"))
    var socialLoginResult: Single<LoginResultEntity> = .just(LoginResultEntity(accessToken: "access", refreshToken: "refresh", signUpToken: nil, isSignUpNeeded: false))
    var signUpResult: Single<LoginResultEntity> = .just(LoginResultEntity(accessToken: "access", refreshToken: "refresh", signUpToken: nil, isSignUpNeeded: false))
    var logoutResult: Single<Void> = .just(())
    var deleteAccountResult: Single<Void> = .just(())

    // MARK: - Call Tracking

    var validateCallCount = 0
    var refreshCallCount = 0
    var socialLoginCallCount = 0
    var logoutCallCount = 0

    // MARK: - Protocol Methods

    func socialLogin(socialToken: SocialTokenEntity) -> Single<LoginResultEntity> {
        socialLoginCallCount += 1
        return socialLoginResult
    }

    func validateAccessToken() -> Single<Void> {
        validateCallCount += 1
        return validateResult
    }

    func refreshToken() -> Single<TokenEntity> {
        refreshCallCount += 1
        return refreshResult
    }

    func signUp(SignUpString: String, request: UserEntity) -> Single<LoginResultEntity> {
        return signUpResult
    }

    func logout() -> Single<Void> {
        logoutCallCount += 1
        return logoutResult
    }

    func deleteAccount() -> Single<Void> {
        return deleteAccountResult
    }
}
