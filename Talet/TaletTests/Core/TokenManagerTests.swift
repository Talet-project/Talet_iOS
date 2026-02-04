//
//  TokenManagerTests.swift
//  TaletTests
//
//  Note: These tests use the actual Keychain, so they must run on a device or simulator.
//  For CI environments, consider using MockTokenManager instead.
//

import XCTest
@testable import Talet

final class TokenManagerTests: XCTestCase {

    var sut: TokenManager!

    override func setUp() {
        super.setUp()
        sut = TokenManager.shared
        // Clean up any existing tokens before each test
        sut.clear()
    }

    override func tearDown() {
        // Clean up after each test
        sut.clear()
        sut = nil
        super.tearDown()
    }

    // MARK: - Save and Load Tests

    func test_accessToken_save_loadsCorrectValue() {
        // Given
        let testToken = "test_access_token_12345"

        // When
        sut.accessToken = testToken

        // Then
        XCTAssertEqual(sut.accessToken, testToken)
    }

    func test_refreshToken_save_loadsCorrectValue() {
        // Given
        let testToken = "test_refresh_token_67890"

        // When
        sut.refreshToken = testToken

        // Then
        XCTAssertEqual(sut.refreshToken, testToken)
    }

    func test_accessToken_overwrite_updatesValue() {
        // Given
        sut.accessToken = "old_token"

        // When
        sut.accessToken = "new_token"

        // Then
        XCTAssertEqual(sut.accessToken, "new_token")
    }

    func test_refreshToken_overwrite_updatesValue() {
        // Given
        sut.refreshToken = "old_refresh"

        // When
        sut.refreshToken = "new_refresh"

        // Then
        XCTAssertEqual(sut.refreshToken, "new_refresh")
    }

    // MARK: - Delete Tests

    func test_accessToken_setNil_deletesToken() {
        // Given
        sut.accessToken = "token_to_delete"
        XCTAssertNotNil(sut.accessToken)

        // When
        sut.accessToken = nil

        // Then
        XCTAssertNil(sut.accessToken)
    }

    func test_refreshToken_setNil_deletesToken() {
        // Given
        sut.refreshToken = "refresh_to_delete"
        XCTAssertNotNil(sut.refreshToken)

        // When
        sut.refreshToken = nil

        // Then
        XCTAssertNil(sut.refreshToken)
    }

    // MARK: - Clear Tests

    func test_clear_removesBothTokens() {
        // Given
        sut.accessToken = "access_123"
        sut.refreshToken = "refresh_456"
        XCTAssertNotNil(sut.accessToken)
        XCTAssertNotNil(sut.refreshToken)

        // When
        sut.clear()

        // Then
        XCTAssertNil(sut.accessToken)
        XCTAssertNil(sut.refreshToken)
    }

    func test_clear_onEmptyKeychain_noError() {
        // Given - Keychain is already empty from setUp

        // When & Then - Should not crash
        sut.clear()
        XCTAssertNil(sut.accessToken)
        XCTAssertNil(sut.refreshToken)
    }

    // MARK: - Initial State Tests

    func test_initialState_tokensAreNil() {
        // Given - fresh state from setUp which clears tokens

        // Then
        XCTAssertNil(sut.accessToken)
        XCTAssertNil(sut.refreshToken)
    }

    // MARK: - Special Character Tests

    func test_accessToken_withSpecialCharacters_savesCorrectly() {
        // Given
        let specialToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IuqwgOuCmOuLpCIsImlhdCI6MTUxNjIzOTAyMn0.test"

        // When
        sut.accessToken = specialToken

        // Then
        XCTAssertEqual(sut.accessToken, specialToken)
    }

    func test_token_withKoreanCharacters_savesCorrectly() {
        // Given - Although tokens shouldn't have Korean, test encoding robustness
        let koreanToken = "테스트_토큰_한글"

        // When
        sut.accessToken = koreanToken

        // Then
        XCTAssertEqual(sut.accessToken, koreanToken)
    }

    func test_token_withEmptyString_treatsAsValidValue() {
        // Given
        let emptyToken = ""

        // When
        sut.accessToken = emptyToken

        // Then
        XCTAssertEqual(sut.accessToken, emptyToken)
    }

    // MARK: - Independent Storage Tests

    func test_accessAndRefreshTokens_storedIndependently() {
        // Given
        let accessValue = "access_value"
        let refreshValue = "refresh_value"

        // When
        sut.accessToken = accessValue
        sut.refreshToken = refreshValue

        // Then - Deleting one shouldn't affect the other
        sut.accessToken = nil
        XCTAssertNil(sut.accessToken)
        XCTAssertEqual(sut.refreshToken, refreshValue)
    }

    // MARK: - Singleton Tests

    func test_shared_returnsSameInstance() {
        // Given
        let instance1 = TokenManager.shared
        let instance2 = TokenManager.shared

        // Then
        XCTAssertTrue(instance1 === instance2)
    }

    func test_shared_changesAreReflectedAcrossReferences() {
        // Given
        let instance1 = TokenManager.shared
        let instance2 = TokenManager.shared

        // When
        instance1.accessToken = "shared_token"

        // Then
        XCTAssertEqual(instance2.accessToken, "shared_token")
    }
}

// MARK: - MockTokenManager Tests

final class MockTokenManagerTests: XCTestCase {

    var sut: MockTokenManager!

    override func setUp() {
        super.setUp()
        sut = MockTokenManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_accessToken_setAndGet() {
        // When
        sut.accessToken = "mock_access"

        // Then
        XCTAssertEqual(sut.accessToken, "mock_access")
    }

    func test_refreshToken_setAndGet() {
        // When
        sut.refreshToken = "mock_refresh"

        // Then
        XCTAssertEqual(sut.refreshToken, "mock_refresh")
    }

    func test_clear_removesBothTokens() {
        // Given
        sut.accessToken = "access"
        sut.refreshToken = "refresh"

        // When
        sut.clear()

        // Then
        XCTAssertNil(sut.accessToken)
        XCTAssertNil(sut.refreshToken)
    }

    func test_conformsToProtocol() {
        // Then
        XCTAssertTrue(sut is TokenManagerProtocol)
    }
}
