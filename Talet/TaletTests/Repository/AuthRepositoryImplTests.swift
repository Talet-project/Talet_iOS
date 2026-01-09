//
//  AuthRepositoryImplTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxBlocking
@testable import Talet

final class AuthRepositoryImplTests: XCTestCase {

    var sut: AuthRepositoryImpl!
    var mockNetworkManager: MockNetworkManager!
    var mockTokenManager: MockTokenManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockTokenManager = MockTokenManager()
        sut = AuthRepositoryImpl(
            network: mockNetworkManager,
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

    // MARK: - socialLogin Tests

    func test_socialLogin_success_withTokens_savesToTokenManager() throws {
        // Given
        let responseData = LoginDataResponseDTO(
            accessToken: "test_access_token",
            refreshToken: "test_refresh_token",
            signUpToken: nil
        )
        let response = BaseResponse(
            success: true,
            message: "success",
            data: responseData,
            error: nil
        )
        mockNetworkManager.stubbedResult = response

        let socialToken = SocialTokenEntity(socialToken: "apple_id_token", platform: "apple")

        // When
        let result = try sut.socialLogin(socialToken: socialToken)
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/auth/apple")
        XCTAssertEqual(mockNetworkManager.lastMethod, .post)
        XCTAssertFalse(result.isSignUpNeeded)
        XCTAssertEqual(mockTokenManager.accessToken, "test_access_token")
        XCTAssertEqual(mockTokenManager.refreshToken, "test_refresh_token")
    }

    func test_socialLogin_needsSignUp_doesNotSaveTokens() throws {
        // Given
        let responseData = LoginDataResponseDTO(
            accessToken: nil,
            refreshToken: nil,
            signUpToken: "signup_token_123"
        )
        let response = BaseResponse(
            success: true,
            message: "success",
            data: responseData,
            error: nil
        )
        mockNetworkManager.stubbedResult = response

        let socialToken = SocialTokenEntity(socialToken: "apple_id_token", platform: "apple")

        // When
        let result = try sut.socialLogin(socialToken: socialToken)
            .toBlocking()
            .single()

        // Then
        XCTAssertTrue(result.isSignUpNeeded)
        XCTAssertEqual(result.signUpToken, "signup_token_123")
        XCTAssertNil(mockTokenManager.accessToken)
        XCTAssertNil(mockTokenManager.refreshToken)
    }

    func test_socialLogin_networkError_throwsError() {
        // Given
        mockNetworkManager.stubbedError = NetworkError.unknown

        let socialToken = SocialTokenEntity(socialToken: "apple_id_token", platform: "apple")

        // When & Then
        XCTAssertThrowsError(
            try sut.socialLogin(socialToken: socialToken)
                .toBlocking()
                .single()
        )
    }

    // MARK: - validateAccessToken Tests

    func test_validateAccessToken_withToken_makesRequest() throws {
        // Given
        mockTokenManager.accessToken = "valid_token"
        mockNetworkManager.stubbedResult = EmptyResponse()

        // When
        _ = try sut.validateAccessToken()
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/auth/validate")
        XCTAssertEqual(mockNetworkManager.lastMethod, .get)
        XCTAssertEqual(mockNetworkManager.lastHeaders?["Authorization"], "Bearer valid_token")
    }

    func test_validateAccessToken_withoutToken_throwsNoTokenError() {
        // Given
        mockTokenManager.accessToken = nil

        // When & Then
        XCTAssertThrowsError(
            try sut.validateAccessToken()
                .toBlocking()
                .single()
        ) { error in
            XCTAssertTrue(error is AuthError)
        }
    }

    // MARK: - logout Tests

    func test_logout_withToken_makesRequest() throws {
        // Given
        mockTokenManager.accessToken = "valid_token"
        mockNetworkManager.stubbedResult = EmptyResponse()

        // When
        _ = try sut.logout()
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/auth/logout")
        XCTAssertEqual(mockNetworkManager.lastMethod, .post)
    }

    func test_logout_withoutToken_throwsNoTokenError() {
        // Given
        mockTokenManager.accessToken = nil

        // When & Then
        XCTAssertThrowsError(
            try sut.logout()
                .toBlocking()
                .single()
        ) { error in
            XCTAssertTrue(error is AuthError)
        }
    }

    // MARK: - deleteAccount Tests

    func test_deleteAccount_withToken_makesDeleteRequest() throws {
        // Given
        mockTokenManager.accessToken = "valid_token"
        mockNetworkManager.stubbedResult = EmptyResponse()

        // When
        _ = try sut.deleteAccount()
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
        XCTAssertEqual(mockNetworkManager.lastEndpoint, "/auth/delete")
        XCTAssertEqual(mockNetworkManager.lastMethod, .delete)
    }
}
