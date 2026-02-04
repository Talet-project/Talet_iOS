//
//  MockUserUseCase.swift
//  TaletTests
//

import RxSwift
@testable import Talet
import Foundation


final class MockUserUseCase: UserUseCaseProtocol {

    // MARK: - Configurable Results

    var fetchUserInfoResult: Single<UserEntity>!
    var updateUserInfoResult: Single<UserEntity>!
    var updateUserImageResult: Single<UserEntity>!

    // MARK: - Call Tracking

    var fetchUserInfoCallCount = 0
    var updateUserInfoCallCount = 0
    var updateUserImageCallCount = 0
    var lastUpdatedUser: UserEntity?
    var lastImageData: Data?

    // MARK: - Protocol Methods

    func fetchUserInfo() -> Single<UserEntity> {
        fetchUserInfoCallCount += 1
        return fetchUserInfoResult
    }

    func updateUserInfo(user: UserEntity) -> Single<UserEntity> {
        updateUserInfoCallCount += 1
        lastUpdatedUser = user
        return updateUserInfoResult
    }

    func updateUserImage(image: Data) -> Single<UserEntity> {
        updateUserImageCallCount += 1
        lastImageData = image
        return updateUserImageResult
    }
}
