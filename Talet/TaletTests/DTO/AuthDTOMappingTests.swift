//
//  AuthDTOMappingTests.swift
//  TaletTests
//

import XCTest
@testable import Talet


// MARK: - LoginDataResponseDTO Mapping Tests

final class LoginDataResponseDTOMappingTests: XCTestCase {

    func test_toEntity_whenLoginSuccess_mapsTokens() {
        // Given
        let dto = LoginDataResponseDTO(
            accessToken: "access_123",
            refreshToken: "refresh_456",
            signUpToken: nil
        )

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertEqual(entity.accessToken, "access_123")
        XCTAssertEqual(entity.refreshToken, "refresh_456")
        XCTAssertNil(entity.signUpToken)
        XCTAssertFalse(entity.isSignUpNeeded)
    }

    func test_toEntity_whenSignUpNeeded_setsIsSignUpNeeded() {
        // Given
        let dto = LoginDataResponseDTO(
            accessToken: nil,
            refreshToken: nil,
            signUpToken: "signup_token_789"
        )

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertNil(entity.accessToken)
        XCTAssertNil(entity.refreshToken)
        XCTAssertEqual(entity.signUpToken, "signup_token_789")
        XCTAssertTrue(entity.isSignUpNeeded)
    }

    func test_toEntity_isSignUpNeeded_dependsOnSignUpTokenNonNil() {
        let withToken = LoginDataResponseDTO(
            accessToken: "a", refreshToken: "r", signUpToken: "s"
        )
        let withoutToken = LoginDataResponseDTO(
            accessToken: "a", refreshToken: "r", signUpToken: nil
        )

        XCTAssertTrue(withToken.toEntity().isSignUpNeeded)
        XCTAssertFalse(withoutToken.toEntity().isSignUpNeeded)
    }
}


// MARK: - SignUpDataResponseDTO Mapping Tests

final class SignUpDataResponseDTOMappingTests: XCTestCase {

    func test_toEntity_mapsTokens() {
        let dto = SignUpDataResponseDTO(
            accessToken: "new_access",
            refreshToken: "new_refresh",
            signUpToken: nil
        )

        let entity = dto.toEntity()

        XCTAssertEqual(entity.accessToken, "new_access")
        XCTAssertEqual(entity.refreshToken, "new_refresh")
        XCTAssertFalse(entity.isSignUpNeeded)
    }

    func test_toEntity_alwaysSetsIsSignUpNeededFalse() {
        // SignUp response always returns isSignUpNeeded = false
        let dto = SignUpDataResponseDTO(
            accessToken: "a",
            refreshToken: "r",
            signUpToken: "leftover_token"
        )

        let entity = dto.toEntity()

        // Even with signUpToken present, isSignUpNeeded is hardcoded false
        XCTAssertFalse(entity.isSignUpNeeded)
    }
}


// MARK: - RefreshDataResponseDTO Mapping Tests

final class RefreshDataResponseDTOMappingTests: XCTestCase {

    func test_toEntity_mapsTokens() {
        let dto = RefreshDataResponseDTO(
            accessToken: "refreshed_access",
            refreshToken: "refreshed_refresh"
        )

        let entity = dto.toEntity()

        XCTAssertEqual(entity.accessToken, "refreshed_access")
        XCTAssertEqual(entity.refreshToken, "refreshed_refresh")
    }
}


// MARK: - SignUpRequestDTO Mapping Tests

final class SignUpRequestDTOMappingTests: XCTestCase {

    func test_init_mapsEntityFieldsCorrectly() {
        // Given
        let entity = UserEntity(
            name: "테스트",
            birth: "2020-05",
            gender: .girl,
            profileImage: nil,
            languages: [.korean, .english]
        )

        // When
        let dto = SignUpRequestDTO(from: entity)

        // Then
        XCTAssertEqual(dto.name, "테스트")
        XCTAssertEqual(dto.birthDate, "2020-05")
        XCTAssertEqual(dto.gender, "여성")
        XCTAssertEqual(dto.nativeLanguages, ["KOREAN", "ENGLISH"])
    }

    func test_init_mapsGenderBoy() {
        let entity = UserEntity(
            name: "Test", birth: "2019-01", gender: .boy,
            profileImage: nil, languages: []
        )

        let dto = SignUpRequestDTO(from: entity)

        XCTAssertEqual(dto.gender, "남성")
    }

    func test_init_mapsAllLanguages() {
        let entity = UserEntity(
            name: "Test", birth: "2020-01", gender: .girl,
            profileImage: nil,
            languages: [.korean, .english, .chinese, .japanese, .vietnamese, .thai]
        )

        let dto = SignUpRequestDTO(from: entity)

        XCTAssertEqual(dto.nativeLanguages, ["KOREAN", "ENGLISH", "CHINESE", "JAPANESE", "VIETNAMESE", "THAI"])
    }
}


// MARK: - UserUpdateRequestDTO Mapping Tests

final class UserUpdateRequestDTOMappingTests: XCTestCase {

    func test_init_mapsEntityFieldsCorrectly() {
        // Given
        let entity = UserEntity(
            name: "수정이름",
            birth: "2021-06",
            gender: .boy,
            profileImage: "image.jpg",
            languages: [.korean, .japanese]
        )

        // When
        let dto = UserUpdateRequestDTO(from: entity)

        // Then - name → nickname, birth → birthday
        XCTAssertEqual(dto.nickname, "수정이름")
        XCTAssertEqual(dto.birthday, "2021-06")
        XCTAssertEqual(dto.gender, "남성")
        XCTAssertEqual(dto.languages, ["KOREAN", "JAPANESE"])
    }

    func test_init_emptyLanguages_mapsToEmptyArray() {
        let entity = UserEntity(
            name: "Test", birth: "2020-01", gender: .girl,
            profileImage: nil, languages: []
        )

        let dto = UserUpdateRequestDTO(from: entity)

        XCTAssertTrue(dto.languages.isEmpty)
    }
}
