//
//  MockUserUseCase.swift
//  TaletTests
//

import Foundation
import RxSwift
@testable import Talet

final class MockUserUseCase: UserUseCaseProtocol {

    // MARK: - Tracking

    var fetchUserInfoCallCount = 0
    var updateUserInfoCallCount = 0
    var updateUserImageCallCount = 0

    var lastUpdateUser: UserEntity?
    var lastImageData: Data?

    // MARK: - Stubbed Responses

    var stubbedFetchUserResult: UserEntity?
    var stubbedFetchUserError: Error?

    var stubbedUpdateUserResult: UserEntity?
    var stubbedUpdateUserError: Error?

    var stubbedUpdateImageResult: UserEntity?
    var stubbedUpdateImageError: Error?

    // MARK: - UserUseCaseProtocol

    func fetchUserInfo() -> Single<UserEntity> {
        fetchUserInfoCallCount += 1

        if let error = stubbedFetchUserError {
            return .error(error)
        }

        if let result = stubbedFetchUserResult {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    func updateUserInfo(user: UserEntity) -> Single<UserEntity> {
        updateUserInfoCallCount += 1
        lastUpdateUser = user

        if let error = stubbedUpdateUserError {
            return .error(error)
        }

        if let result = stubbedUpdateUserResult {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    func updateUserImage(image: Data) -> Single<UserEntity> {
        updateUserImageCallCount += 1
        lastImageData = image

        if let error = stubbedUpdateImageError {
            return .error(error)
        }

        if let result = stubbedUpdateImageResult {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    // MARK: - Helpers

    func reset() {
        fetchUserInfoCallCount = 0
        updateUserInfoCallCount = 0
        updateUserImageCallCount = 0

        lastUpdateUser = nil
        lastImageData = nil

        stubbedFetchUserResult = nil
        stubbedFetchUserError = nil
        stubbedUpdateUserResult = nil
        stubbedUpdateUserError = nil
        stubbedUpdateImageResult = nil
        stubbedUpdateImageError = nil
    }
}
