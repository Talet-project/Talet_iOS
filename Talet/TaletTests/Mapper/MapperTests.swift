//
//  MapperTests.swift
//  TaletTests
//

import XCTest
@testable import Talet

// MARK: - GenderMapper Tests

final class GenderMapperTests: XCTestCase {

    // MARK: - fromAPI Tests

    func test_fromAPI_여성_returnsGirl() throws {
        // When
        let result = try GenderMapper.fromAPI("여성")

        // Then
        XCTAssertEqual(result, .girl)
    }

    func test_fromAPI_남성_returnsBoy() throws {
        // When
        let result = try GenderMapper.fromAPI("남성")

        // Then
        XCTAssertEqual(result, .boy)
    }

    func test_fromAPI_invalidValue_throwsDecodingError() {
        // Given
        let invalidGender = "Unknown"

        // When & Then
        XCTAssertThrowsError(try GenderMapper.fromAPI(invalidGender)) { error in
            guard case NetworkError.decodingError = error else {
                XCTFail("Expected NetworkError.decodingError but got \(error)")
                return
            }
        }
    }

    func test_fromAPI_emptyString_throwsDecodingError() {
        // When & Then
        XCTAssertThrowsError(try GenderMapper.fromAPI("")) { error in
            guard case NetworkError.decodingError = error else {
                XCTFail("Expected NetworkError.decodingError")
                return
            }
        }
    }

    func test_fromAPI_caseSensitive_exactMatchRequired() {
        // Korean characters should match exactly
        XCTAssertThrowsError(try GenderMapper.fromAPI("여 성"))  // Extra space
        XCTAssertThrowsError(try GenderMapper.fromAPI("남 성"))  // Extra space
    }

    // MARK: - toAPI Tests

    func test_toAPI_girl_returns여성() {
        // When
        let result = GenderMapper.toAPI(.girl)

        // Then
        XCTAssertEqual(result, "여성")
    }

    func test_toAPI_boy_returns남성() {
        // When
        let result = GenderMapper.toAPI(.boy)

        // Then
        XCTAssertEqual(result, "남성")
    }

    // MARK: - Round Trip Tests

    func test_roundTrip_girl_preservesValue() throws {
        // Given
        let original: GenderEntity = .girl

        // When
        let apiValue = GenderMapper.toAPI(original)
        let restored = try GenderMapper.fromAPI(apiValue)

        // Then
        XCTAssertEqual(restored, original)
    }

    func test_roundTrip_boy_preservesValue() throws {
        // Given
        let original: GenderEntity = .boy

        // When
        let apiValue = GenderMapper.toAPI(original)
        let restored = try GenderMapper.fromAPI(apiValue)

        // Then
        XCTAssertEqual(restored, original)
    }
}

// MARK: - LanguageMapper Tests

final class LanguageMapperTests: XCTestCase {

    // MARK: - fromAPI Tests

    func test_fromAPI_KOREAN_returnsKorean() {
        // When
        let result = LanguageMapper.fromAPI("KOREAN")

        // Then
        XCTAssertEqual(result, .korean)
    }

    func test_fromAPI_ENGLISH_returnsEnglish() {
        // When
        let result = LanguageMapper.fromAPI("ENGLISH")

        // Then
        XCTAssertEqual(result, .english)
    }

    func test_fromAPI_CHINESE_returnsChinese() {
        // When
        let result = LanguageMapper.fromAPI("CHINESE")

        // Then
        XCTAssertEqual(result, .chinese)
    }

    func test_fromAPI_JAPANESE_returnsJapanese() {
        // When
        let result = LanguageMapper.fromAPI("JAPANESE")

        // Then
        XCTAssertEqual(result, .japanese)
    }

    func test_fromAPI_VIETNAMESE_returnsVietnamese() {
        // When
        let result = LanguageMapper.fromAPI("VIETNAMESE")

        // Then
        XCTAssertEqual(result, .vietnamese)
    }

    func test_fromAPI_THAI_returnsThai() {
        // When
        let result = LanguageMapper.fromAPI("THAI")

        // Then
        XCTAssertEqual(result, .thai)
    }

    func test_fromAPI_lowercase_returnsCorrectValue() {
        // Language mapper converts to uppercase internally
        XCTAssertEqual(LanguageMapper.fromAPI("korean"), .korean)
        XCTAssertEqual(LanguageMapper.fromAPI("english"), .english)
        XCTAssertEqual(LanguageMapper.fromAPI("Chinese"), .chinese)
    }

    func test_fromAPI_invalidValue_returnsNil() {
        // When
        let result = LanguageMapper.fromAPI("SPANISH")

        // Then
        XCTAssertNil(result)
    }

    func test_fromAPI_emptyString_returnsNil() {
        // When
        let result = LanguageMapper.fromAPI("")

        // Then
        XCTAssertNil(result)
    }

    // MARK: - toAPI Tests

    func test_toAPI_korean_returnsKOREAN() {
        XCTAssertEqual(LanguageMapper.toAPI(.korean), "KOREAN")
    }

    func test_toAPI_english_returnsENGLISH() {
        XCTAssertEqual(LanguageMapper.toAPI(.english), "ENGLISH")
    }

    func test_toAPI_chinese_returnsCHINESE() {
        XCTAssertEqual(LanguageMapper.toAPI(.chinese), "CHINESE")
    }

    func test_toAPI_japanese_returnsJAPANESE() {
        XCTAssertEqual(LanguageMapper.toAPI(.japanese), "JAPANESE")
    }

    func test_toAPI_vietnamese_returnsVIETNAMESE() {
        XCTAssertEqual(LanguageMapper.toAPI(.vietnamese), "VIETNAMESE")
    }

    func test_toAPI_thai_returnsTHAI() {
        XCTAssertEqual(LanguageMapper.toAPI(.thai), "THAI")
    }

    // MARK: - Round Trip Tests

    func test_roundTrip_allLanguages_preserveValues() {
        for language in LanguageEntity.allCases {
            let apiValue = LanguageMapper.toAPI(language)
            let restored = LanguageMapper.fromAPI(apiValue)
            XCTAssertEqual(restored, language, "Round trip failed for \(language)")
        }
    }

    // MARK: - Bulk Conversion Tests

    func test_fromAPI_multipleLanguages_returnsCorrectArray() {
        // Given
        let apiLanguages = ["KOREAN", "ENGLISH", "INVALID", "JAPANESE"]

        // When
        let results = apiLanguages.compactMap(LanguageMapper.fromAPI)

        // Then
        XCTAssertEqual(results.count, 3)  // INVALID is filtered out
        XCTAssertEqual(results, [.korean, .english, .japanese])
    }
}

// MARK: - GenderEntity Extension Tests

final class GenderEntityExtensionTests: XCTestCase {

    func test_displayText_girl_returns여아() {
        XCTAssertEqual(GenderEntity.girl.displayText, "여아")
    }

    func test_displayText_boy_returns남아() {
        XCTAssertEqual(GenderEntity.boy.displayText, "남아")
    }

    func test_defaultProfileImage_girl_returnsProfileGirl() {
        XCTAssertEqual(GenderEntity.girl.defaultProfileImage, .profileGirl)
    }

    func test_defaultProfileImage_boy_returnsProfileBoy() {
        XCTAssertEqual(GenderEntity.boy.defaultProfileImage, .profileBoy)
    }
}

// MARK: - LanguageEntity Extension Tests

final class LanguageEntityExtensionTests: XCTestCase {

    func test_localizedName_allLanguages() {
        XCTAssertEqual(LanguageEntity.korean.localizedName, "한국어")
        XCTAssertEqual(LanguageEntity.english.localizedName, "English")
        XCTAssertEqual(LanguageEntity.chinese.localizedName, "中文")
        XCTAssertEqual(LanguageEntity.japanese.localizedName, "日本語")
        XCTAssertEqual(LanguageEntity.vietnamese.localizedName, "Tiếng Việt")
        XCTAssertEqual(LanguageEntity.thai.localizedName, "ภาษาไทย")
    }

    func test_flag_allLanguages() {
        XCTAssertEqual(LanguageEntity.korean.flag, "🇰🇷")
        XCTAssertEqual(LanguageEntity.english.flag, "🇺🇸")
        XCTAssertEqual(LanguageEntity.chinese.flag, "🇨🇳")
        XCTAssertEqual(LanguageEntity.japanese.flag, "🇯🇵")
        XCTAssertEqual(LanguageEntity.vietnamese.flag, "🇻🇳")
        XCTAssertEqual(LanguageEntity.thai.flag, "🇹🇭")
    }

    func test_displayText_containsFlagAndLocalizedName() {
        for language in LanguageEntity.allCases {
            let displayText = language.displayText
            XCTAssertTrue(displayText.contains(language.flag))
            XCTAssertTrue(displayText.contains(language.localizedName))
        }
    }

    func test_allCases_containsAllLanguages() {
        XCTAssertEqual(LanguageEntity.allCases.count, 6)
        XCTAssertTrue(LanguageEntity.allCases.contains(.korean))
        XCTAssertTrue(LanguageEntity.allCases.contains(.english))
        XCTAssertTrue(LanguageEntity.allCases.contains(.chinese))
        XCTAssertTrue(LanguageEntity.allCases.contains(.japanese))
        XCTAssertTrue(LanguageEntity.allCases.contains(.vietnamese))
        XCTAssertTrue(LanguageEntity.allCases.contains(.thai))
    }
}
