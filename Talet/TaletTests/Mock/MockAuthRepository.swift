//
//  MockAuthRepository.swift
//  TaletTests
//

import Foundation
import RxSwift
@testable import Talet

final class MockAuthRepository: AuthRepositoryProtocol {

    // MARK: - Tracking

    var socialLoginCallCount = 0
    var validateAccessTokenCallCount = 0
    var refreshAccessTokenCallCount = 0
    var signUpCallCount = 0
    var logoutCallCount = 0
    var deleteAccountCallCount = 0

    var lastSocialToken: SocialTokenEntity?
    var lastSignUpToken: String?
    var lastSignUpRequest: UserEntity?

    // MARK: - Stubbed Responses

    var stubbedSocialLoginResult: LoginResultEntity?
    var stubbedSocialLoginError: Error?

    var stubbedValidateResult: Void = ()
    var stubbedValidateError: Error?

    var stubbedRefreshResult: Void = ()
    var stubbedRefreshError: Error?

    var stubbedSignUpResult: LoginResultEntity?
    var stubbedSignUpError: Error?

    var stubbedLogoutResult: Void = ()
    var stubbedLogoutError: Error?

    var stubbedDeleteAccountResult: Void = ()
    var stubbedDeleteAccountError: Error?

    // MARK: - AuthRepositoryProtocol

    func socialLogin(socialToken: SocialTokenEntity) -> Single<LoginResultEntity> {
        socialLoginCallCount += 1
        lastSocialToken = socialToken

        if let error = stubbedSocialLoginError {
            return .error(error)
        }

        if let result = stubbedSocialLoginResult {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    func validateAccessToken() -> Single<Void> {
        validateAccessTokenCallCount += 1

        if let error = stubbedValidateError {
            return .error(error)
        }

        return .just(stubbedValidateResult)
    }

    func refreshAccessToken() -> Single<Void> {
        refreshAccessTokenCallCount += 1

        if let error = stubbedRefreshError {
            return .error(error)
        }

        return .just(stubbedRefreshResult)
    }

    func signUp(SignUpString: String, request: UserEntity) -> Single<LoginResultEntity> {
        signUpCallCount += 1
        lastSignUpToken = SignUpString
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
        validateAccessTokenCallCount = 0
        refreshAccessTokenCallCount = 0
        signUpCallCount = 0
        logoutCallCount = 0
        deleteAccountCallCount = 0

        lastSocialToken = nil
        lastSignUpToken = nil
        lastSignUpRequest = nil

        stubbedSocialLoginResult = nil
        stubbedSocialLoginError = nil
        stubbedValidateError = nil
        stubbedRefreshError = nil
        stubbedSignUpResult = nil
        stubbedSignUpError = nil
        stubbedLogoutError = nil
        stubbedDeleteAccountError = nil
    }
}
