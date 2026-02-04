//
//  BookTagMapperTests.swift
//  TaletTests
//

import XCTest
@testable import Talet


final class BookTagMapperTests: XCTestCase {

    // MARK: - fromAPI Tests

    func test_fromAPI_courage_returnsCourage() {
        XCTAssertEqual(BookTagMapper.fromAPI("courage"), .courage)
    }

    func test_fromAPI_wisdom_returnsWisdom() {
        XCTAssertEqual(BookTagMapper.fromAPI("wisdom"), .wisdom)
    }

    func test_fromAPI_goodAndEvil_returnsGoodAndEvil() {
        XCTAssertEqual(BookTagMapper.fromAPI("goodAndEvil"), .goodAndEvil)
    }

    func test_fromAPI_sharing_returnsSharing() {
        XCTAssertEqual(BookTagMapper.fromAPI("sharing"), .sharing)
    }

    func test_fromAPI_familyLove_returnsFamilyLove() {
        XCTAssertEqual(BookTagMapper.fromAPI("familyLove"), .familyLove)
    }

    func test_fromAPI_friendship_returnsFriendship() {
        XCTAssertEqual(BookTagMapper.fromAPI("friendship"), .friendship)
    }

    func test_fromAPI_justice_returnsJustice() {
        XCTAssertEqual(BookTagMapper.fromAPI("justice"), .justice)
    }

    func test_fromAPI_growth_returnsGrowth() {
        XCTAssertEqual(BookTagMapper.fromAPI("growth"), .growth)
    }

    func test_fromAPI_invalidValue_returnsNil() {
        XCTAssertNil(BookTagMapper.fromAPI("unknown"))
    }

    func test_fromAPI_emptyString_returnsNil() {
        XCTAssertNil(BookTagMapper.fromAPI(""))
    }

    func test_fromAPI_caseSensitive_uppercaseFails() {
        XCTAssertNil(BookTagMapper.fromAPI("Courage"))
        XCTAssertNil(BookTagMapper.fromAPI("COURAGE"))
    }

    // MARK: - toAPI Tests

    func test_toAPI_courage_returnsCourageString() {
        XCTAssertEqual(BookTagMapper.toAPI(.courage), "courage")
    }

    func test_toAPI_wisdom_returnsWisdomString() {
        XCTAssertEqual(BookTagMapper.toAPI(.wisdom), "wisdom")
    }

    func test_toAPI_goodAndEvil_returnsGoodAndEvilString() {
        XCTAssertEqual(BookTagMapper.toAPI(.goodAndEvil), "goodAndEvil")
    }

    func test_toAPI_sharing_returnsSharingString() {
        XCTAssertEqual(BookTagMapper.toAPI(.sharing), "sharing")
    }

    func test_toAPI_familyLove_returnsFamilyLoveString() {
        XCTAssertEqual(BookTagMapper.toAPI(.familyLove), "familyLove")
    }

    func test_toAPI_friendship_returnsFriendshipString() {
        XCTAssertEqual(BookTagMapper.toAPI(.friendship), "friendship")
    }

    func test_toAPI_justice_returnsJusticeString() {
        XCTAssertEqual(BookTagMapper.toAPI(.justice), "justice")
    }

    func test_toAPI_growth_returnsGrowthString() {
        XCTAssertEqual(BookTagMapper.toAPI(.growth), "growth")
    }

    // MARK: - Round Trip Tests

    func test_roundTrip_allTags_preserveValues() {
        let allTags: [BookTag] = [.courage, .wisdom, .goodAndEvil, .sharing, .familyLove, .friendship, .justice, .growth]

        for tag in allTags {
            let apiValue = BookTagMapper.toAPI(tag)
            let restored = BookTagMapper.fromAPI(apiValue)
            XCTAssertEqual(restored, tag, "Round trip failed for \(tag)")
        }
    }

    // MARK: - Bulk Conversion Tests

    func test_fromAPI_multipleValues_filtersInvalid() {
        // Given
        let apiTags = ["courage", "invalid", "friendship", "unknown", "growth"]

        // When
        let results = apiTags.compactMap(BookTagMapper.fromAPI)

        // Then
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(results[0], .courage)
        XCTAssertEqual(results[1], .friendship)
        XCTAssertEqual(results[2], .growth)
    }
}
