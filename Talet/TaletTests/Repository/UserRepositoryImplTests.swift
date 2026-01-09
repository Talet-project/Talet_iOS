//
//  UserRepositoryImplTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxBlocking
@testable import Talet

final class UserRepositoryImplTests: XCTestCase {

    var sut: UserRepositoryImpl!
    var mockNetworkManager: MockNetworkManager!
    var mockTokenManager: MockTokenManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockTokenManager = MockTokenManager()
        sut = UserRepositoryImpl(
            networkManager: mockNetworkManager,
            tokenManager: mockTokenManager
        )
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        mockTokenManager = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - fetchUserInfo Tests

    func test_fetchUserInfo_withToken_success() throws {
        // Given
        mockTokenManager.accessToken = "valid_token"

        let responseData = UserInfoDataResponseDTO(
            profileImage: "https://example.com/image.jpg",
            nickname: "TestUser",
            gender: "남성",
            birthday: "2020-05",
            languages: ["KOREAN", "ENGLISH"]
        )
        let response = BaseResponse(
            success: true,
            message: "success",
            data: responseData,
            error: nil
        )
        mockNetworkManager.stubbedResult = response

        // When
        let result = try sut.fetchUserInfo()
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/member/me")
        XCTAssertEqual(mockNetworkManager.lastMethod, .get)
        XCTAssertEqual(mockNetworkManager.lastHeaders?["Authorization"], "Bearer valid_token")
        XCTAssertEqual(result.name, "TestUser")
        XCTAssertEqual(result.birth, "2020-05")
        XCTAssertEqual(result.gender, .boy)
        XCTAssertEqual(result.languages.count, 2)
    }

    func test_fetchUserInfo_withoutToken_throwsNoTokenError() {
        // Given
        mockTokenManager.accessToken = nil

        // When & Then
        XCTAssertThrowsError(
            try sut.fetchUserInfo()
                .toBlocking()
                .single()
        ) { error in
            XCTAssertTrue(error is AuthError)
            XCTAssertEqual(error as? AuthError, AuthError.noToken)
        }
    }

    func test_fetchUserInfo_networkError_throwsError() {
        // Given
        mockTokenManager.accessToken = "valid_token"
        mockNetworkManager.stubbedError = NetworkError.unknown

        // When & Then
        XCTAssertThrowsError(
            try sut.fetchUserInfo()
                .toBlocking()
                .single()
        )
    }

    // MARK: - updateUserInfo Tests

    func test_updateUserInfo_withToken_success() throws {
        // Given
        mockTokenManager.accessToken = "valid_token"

        let responseData = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "UpdatedUser",
            gender: "여성",
            birthday: "2019-03",
            languages: ["KOREAN"]
        )
        let response = BaseResponse(
            success: true,
            message: "success",
            data: responseData,
            error: nil
        )
        mockNetworkManager.stubbedResult = response

        let request = UserEntity(
            name: "UpdatedUser",
            birth: "2019-03",
            gender: .girl,
            profileImage: nil,
            languages: [.korean]
        )

        // When
        let result = try sut.updateUserInfo(request: request)
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/member/update")
        XCTAssertEqual(mockNetworkManager.lastMethod, .post)
        XCTAssertEqual(result.name, "UpdatedUser")
        XCTAssertEqual(result.gender, .girl)
    }

    func test_updateUserInfo_withoutToken_throwsNoTokenError() {
        // Given
        mockTokenManager.accessToken = nil

        let request = UserEntity(
            name: "Test",
            birth: "2020-01",
            gender: .boy,
            profileImage: nil,
            languages: [.korean]
        )

        // When & Then
        XCTAssertThrowsError(
            try sut.updateUserInfo(request: request)
                .toBlocking()
                .single()
        ) { error in
            XCTAssertEqual(error as? AuthError, AuthError.noToken)
        }
    }

    // MARK: - updateUserImage Tests

    func test_updateUserImage_withToken_success() throws {
        // Given
        mockTokenManager.accessToken = "valid_token"

        let responseData = UserInfoDataResponseDTO(
            profileImage: "https://example.com/new_image.jpg",
            nickname: "TestUser",
            gender: "남성",
            birthday: "2020-05",
            languages: ["KOREAN"]
        )
        let response = BaseResponse(
            success: true,
            message: "success",
            data: responseData,
            error: nil
        )
        mockNetworkManager.stubbedResult = response

        let imageData = Data([0x00, 0x01, 0x02])

        // When
        let result = try sut.updateUserImage(imageData: imageData)
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.uploadCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/member/update/image")
        XCTAssertEqual(mockNetworkManager.lastHeaders?["Authorization"], "Bearer valid_token")
        XCTAssertEqual(result.profileImage, "https://example.com/new_image.jpg")
    }

    func test_updateUserImage_withoutToken_throwsNoTokenError() {
        // Given
        mockTokenManager.accessToken = nil

        let imageData = Data([0x00, 0x01, 0x02])

        // When & Then
        XCTAssertThrowsError(
            try sut.updateUserImage(imageData: imageData)
                .toBlocking()
                .single()
        ) { error in
            XCTAssertEqual(error as? AuthError, AuthError.noToken)
        }
    }
}
