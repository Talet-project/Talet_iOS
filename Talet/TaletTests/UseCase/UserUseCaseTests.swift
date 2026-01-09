//
//  UserUseCaseTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxBlocking
@testable import Talet

final class UserUseCaseTests: XCTestCase {

    var sut: UserUseCase!
    var mockRepository: MockUserRepository!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = UserUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - fetchUserInfo Tests

    func test_fetchUserInfo_success_returnsUserEntity() throws {
        // Given
        let expectedUser = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .boy,
            profileImage: "https://example.com/image.jpg",
            languages: [.korean, .english]
        )
        mockRepository.stubbedFetchUserResult = expectedUser

        // When
        let result = try sut.fetchUserInfo()
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockRepository.fetchUserInfoCallCount, 1)
        XCTAssertEqual(result.name, "TestUser")
        XCTAssertEqual(result.birth, "2020-05")
        XCTAssertEqual(result.gender, .boy)
        XCTAssertEqual(result.languages.count, 2)
    }

    func test_fetchUserInfo_repositoryError_throwsError() {
        // Given
        mockRepository.stubbedFetchUserError = NetworkError.unknown

        // When & Then
        XCTAssertThrowsError(
            try sut.fetchUserInfo()
                .toBlocking()
                .single()
        )
        XCTAssertEqual(mockRepository.fetchUserInfoCallCount, 1)
    }

    // MARK: - updateUserInfo Tests

    func test_updateUserInfo_success_returnsUpdatedUser() throws {
        // Given
        let updatedUser = UserEntity(
            name: "UpdatedName",
            birth: "2019-03",
            gender: .girl,
            profileImage: nil,
            languages: [.korean]
        )
        mockRepository.stubbedUpdateUserResult = updatedUser

        let userRequest = UserEntity(
            name: "UpdatedName",
            birth: "2019-03",
            gender: .girl,
            profileImage: nil,
            languages: [.korean]
        )

        // When
        let result = try sut.updateUserInfo(user: userRequest)
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockRepository.updateUserInfoCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdateUserRequest?.name, "UpdatedName")
        XCTAssertEqual(result.name, "UpdatedName")
        XCTAssertEqual(result.gender, .girl)
    }

    func test_updateUserInfo_repositoryError_throwsError() {
        // Given
        mockRepository.stubbedUpdateUserError = AuthError.noToken

        let userRequest = UserEntity(
            name: "Test",
            birth: "2020-01",
            gender: .boy,
            profileImage: nil,
            languages: [.korean]
        )

        // When & Then
        XCTAssertThrowsError(
            try sut.updateUserInfo(user: userRequest)
                .toBlocking()
                .single()
        ) { error in
            XCTAssertEqual(error as? AuthError, AuthError.noToken)
        }
    }

    // MARK: - updateUserImage Tests

    func test_updateUserImage_success_returnsUserWithNewImage() throws {
        // Given
        let userWithNewImage = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .boy,
            profileImage: "https://example.com/new_image.jpg",
            languages: [.korean]
        )
        mockRepository.stubbedUpdateImageResult = userWithNewImage

        let imageData = Data([0x00, 0x01, 0x02, 0x03])

        // When
        let result = try sut.updateUserImage(image: imageData)
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockRepository.updateUserImageCallCount, 1)
        XCTAssertEqual(mockRepository.lastImageData, imageData)
        XCTAssertEqual(result.profileImage, "https://example.com/new_image.jpg")
    }

    func test_updateUserImage_repositoryError_throwsError() {
        // Given
        mockRepository.stubbedUpdateImageError = NetworkError.serverError(500)

        let imageData = Data([0x00, 0x01])

        // When & Then
        XCTAssertThrowsError(
            try sut.updateUserImage(image: imageData)
                .toBlocking()
                .single()
        )
        XCTAssertEqual(mockRepository.updateUserImageCallCount, 1)
    }
}
