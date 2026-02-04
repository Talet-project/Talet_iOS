//
//  UserInfoDTOMappingTests.swift
//  TaletTests
//

import XCTest
@testable import Talet


final class UserInfoDTOMappingTests: XCTestCase {

    func test_toEntity_mapsAllFields() throws {
        // Given
        let dto = UserInfoDataResponseDTO(
            profileImage: "https://example.com/profile.jpg",
            nickname: "테스트유저",
            gender: "여성",
            birthday: "2020-05-15",
            languages: ["KOREAN", "ENGLISH"]
        )

        // When
        let entity = try dto.toEntity()

        // Then
        XCTAssertEqual(entity.name, "테스트유저")
        XCTAssertEqual(entity.birth, "2020-05-15")
        XCTAssertEqual(entity.gender, .girl)
        XCTAssertEqual(entity.profileImage, "https://example.com/profile.jpg")
        XCTAssertEqual(entity.languages.count, 2)
        XCTAssertEqual(entity.languages[0], .korean)
        XCTAssertEqual(entity.languages[1], .english)
    }

    func test_toEntity_nicknameMapsToName() throws {
        // Given - DTO uses `nickname`, Entity uses `name`
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "닉네임필드",
            gender: "남성",
            birthday: "2019-01-01",
            languages: ["KOREAN"]
        )

        // When
        let entity = try dto.toEntity()

        // Then
        XCTAssertEqual(entity.name, "닉네임필드")
    }

    func test_toEntity_birthdayMapsToBirth() throws {
        // Given - DTO uses `birthday`, Entity uses `birth`
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "Test",
            gender: "남성",
            birthday: "2021-12-25",
            languages: []
        )

        // When
        let entity = try dto.toEntity()

        // Then
        XCTAssertEqual(entity.birth, "2021-12-25")
    }

    func test_toEntity_whenProfileImageNil_entityProfileImageNil() throws {
        // Given
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "Test",
            gender: "남성",
            birthday: "2020-01-01",
            languages: []
        )

        // When
        let entity = try dto.toEntity()

        // Then
        XCTAssertNil(entity.profileImage)
    }

    func test_toEntity_whenInvalidGender_throwsDecodingError() {
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "Test",
            gender: "INVALID",
            birthday: "2020-01-01",
            languages: []
        )

        XCTAssertThrowsError(try dto.toEntity()) { error in
            guard case NetworkError.decodingError = error else {
                XCTFail("Expected decodingError, got \(error)")
                return
            }
        }
    }

    func test_toEntity_filtersInvalidLanguages() throws {
        // Given
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "Test",
            gender: "여성",
            birthday: "2020-01-01",
            languages: ["KOREAN", "INVALID", "JAPANESE", "SPANISH"]
        )

        // When
        let entity = try dto.toEntity()

        // Then - INVALID and SPANISH are filtered out
        XCTAssertEqual(entity.languages.count, 2)
        XCTAssertEqual(entity.languages[0], .korean)
        XCTAssertEqual(entity.languages[1], .japanese)
    }

    func test_toEntity_whenEmptyLanguages_returnsEmptyArray() throws {
        // Given
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "Test",
            gender: "남성",
            birthday: "2020-01-01",
            languages: []
        )

        // When
        let entity = try dto.toEntity()

        // Then
        XCTAssertTrue(entity.languages.isEmpty)
    }

    func test_toEntity_allSixLanguages_mapCorrectly() throws {
        // Given
        let dto = UserInfoDataResponseDTO(
            profileImage: nil,
            nickname: "Polyglot",
            gender: "여성",
            birthday: "2020-01-01",
            languages: ["KOREAN", "ENGLISH", "CHINESE", "JAPANESE", "VIETNAMESE", "THAI"]
        )

        // When
        let entity = try dto.toEntity()

        // Then
        XCTAssertEqual(entity.languages.count, 6)
        XCTAssertEqual(entity.languages[0], .korean)
        XCTAssertEqual(entity.languages[1], .english)
        XCTAssertEqual(entity.languages[2], .chinese)
        XCTAssertEqual(entity.languages[3], .japanese)
        XCTAssertEqual(entity.languages[4], .vietnamese)
        XCTAssertEqual(entity.languages[5], .thai)
    }
}
