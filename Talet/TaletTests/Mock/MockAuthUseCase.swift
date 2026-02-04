//
//  MockAuthUseCase.swift
//  TaletTests
//

import RxSwift
@testable import Talet


final class MockAuthUseCase: AuthUseCaseProtocol {

    // MARK: - Configurable Results

    var socialLoginResult: Single<LoginResultEntity> = .just(
        LoginResultEntity(accessToken: "access", refreshToken: "refresh", signUpToken: nil, isSignUpNeeded: false)
    )
    var autoLoginResult: Single<Void> = .just(())
    var signUpResult: Single<LoginResultEntity> = .just(
        LoginResultEntity(accessToken: "access", refreshToken: "refresh", signUpToken: nil, isSignUpNeeded: false)
    )
    var logoutResult: Single<Void> = .just(())
    var deleteAccountResult: Single<Void> = .just(())

    // MARK: - Call Tracking

    var socialLoginCallCount = 0
    var lastLoginPlatform: LoginPlatform?
    var logoutCallCount = 0
    var deleteAccountCallCount = 0
    var signUpCallCount = 0

    // MARK: - Protocol Methods

    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity> {
        socialLoginCallCount += 1
        lastLoginPlatform = platform
        return socialLoginResult
    }

    func autoLogin() -> Single<Void> {
        return autoLoginResult
    }

    func signUp(signUpToken: String, request: UserEntity) -> Single<LoginResultEntity> {
        signUpCallCount += 1
        return signUpResult
    }

    func logout() -> Single<Void> {
        logoutCallCount += 1
        return logoutResult
    }

    func deleteAccount() -> Single<Void> {
        deleteAccountCallCount += 1
        return deleteAccountResult
    }
}
