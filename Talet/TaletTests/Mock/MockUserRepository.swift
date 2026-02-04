//
//  MockUserRepository.swift
//  TaletTests
//

import RxSwift
@testable import Talet
import Foundation


final class MockUserRepository: UserRepositoryProtocol {

    // MARK: - Configurable Results

    var fetchUserInfoResult: Single<UserEntity>!
    var updateUserInfoResult: Single<UserEntity>!
    var updateUserImageResult: Single<UserEntity>!

    // MARK: - Call Tracking

    var fetchUserInfoCallCount = 0
    var updateUserInfoCallCount = 0
    var lastUpdatedUser: UserEntity?

    // MARK: - Protocol Methods

    func fetchUserInfo() -> Single<UserEntity> {
        fetchUserInfoCallCount += 1
        return fetchUserInfoResult
    }

    func updateUserInfo(request: UserEntity) -> Single<UserEntity> {
        updateUserInfoCallCount += 1
        lastUpdatedUser = request
        return updateUserInfoResult
    }

    func updateUserImage(imageData: Data) -> Single<UserEntity> {
        return updateUserImageResult
    }
}
