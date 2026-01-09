//
//  MockAuthUseCase.swift
//  TaletTests
//

import Foundation
import RxSwift
@testable import Talet

final class MockAuthUseCase: AuthUseCaseProtocol {

    // MARK: - Tracking

    var socialLoginCallCount = 0
    var autoLoginCallCount = 0
    var signUpCallCount = 0
    var logoutCallCount = 0
    var deleteAccountCallCount = 0

    var lastLoginPlatform: LoginPlatform?
    var lastSignUpToken: String?
    var lastSignUpRequest: UserEntity?

    // MARK: - Stubbed Responses

    var stubbedSocialLoginResult: LoginResultEntity?
    var stubbedSocialLoginError: Error?

    var stubbedAutoLoginResult: Void = ()
    var stubbedAutoLoginError: Error?

    var stubbedSignUpResult: LoginResultEntity?
    var stubbedSignUpError: Error?

    var stubbedLogoutResult: Void = ()
    var stubbedLogoutError: Error?

    var stubbedDeleteAccountResult: Void = ()
    var stubbedDeleteAccountError: Error?

    // MARK: - AuthUseCaseProtocol

    func socialLogin(platform: LoginPlatform) -> Single<LoginResultEntity> {
        socialLoginCallCount += 1
        lastLoginPlatform = platform

        if let error = stubbedSocialLoginError {
            return .error(error)
        }

        if let result = stubbedSocialLoginResult {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    func autoLogin() -> Single<Void> {
        autoLoginCallCount += 1

        if let error = stubbedAutoLoginError {
            return .error(error)
        }

        return .just(stubbedAutoLoginResult)
    }

    func signUp(signUpToken: String, request: UserEntity) -> Single<LoginResultEntity> {
        signUpCallCount += 1
        lastSignUpToken = signUpToken
        lastSignUpRequest = request

        if let error = stubbedSignUpError {
            return .error(error)
        }

        if let result = stubbedSignUpResult {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    func logout() -> Single<Void> {
        logoutCallCount += 1

        if let error = stubbedLogoutError {
            return .error(error)
        }

        return .just(stubbedLogoutResult)
    }

    func deleteAccount() -> Single<Void> {
        deleteAccountCallCount += 1

        if let error = stubbedDeleteAccountError {
            return .error(error)
        }

        return .just(stubbedDeleteAccountResult)
    }

    // MARK: - Helpers

    func reset() {
        socialLoginCallCount = 0
        autoLoginCallCount = 0
        signUpCallCount = 0
        logoutCallCount = 0
        deleteAccountCallCount = 0

        lastLoginPlatform = nil
        lastSignUpToken = nil
        lastSignUpRequest = nil

        stubbedSocialLoginResult = nil
        stubbedSocialLoginError = nil
        stubbedAutoLoginError = nil
        stubbedSignUpResult = nil
        stubbedSignUpError = nil
        stubbedLogoutError = nil
        stubbedDeleteAccountError = nil
    }
}
