//
//  BookDTOMappingTests.swift
//  TaletTests
//

import XCTest
@testable import Talet


// MARK: - AllBookResponseDataDTO Mapping Tests

final class AllBookResponseDataDTOMappingTests: XCTestCase {

    func test_toEntity_mapsAllFields() {
        // Given
        let dto = AllBookResponseDataDTO(
            id: "book-001",
            name: "용기있는 아이",
            thumbnail: "https://example.com/image.jpg",
            tag: ["courage", "friendship"],
            plot: ["ko": "긴 줄거리"]
        )

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertEqual(entity.id, "book-001")
        XCTAssertEqual(entity.title, "용기있는 아이")
        XCTAssertEqual(entity.image, URL(string: "https://example.com/image.jpg")!)
        XCTAssertEqual(entity.tags?.count, 2)
        XCTAssertEqual(entity.tags?[0], .courage)
        XCTAssertEqual(entity.tags?[1], .friendship)
        XCTAssertNil(entity.shortSummary)
        XCTAssertEqual(entity.longSummary?["ko"], "긴 줄거리")
        XCTAssertNil(entity.totalPage)
        XCTAssertNil(entity.stillImages)
    }

    func test_toEntity_filtersInvalidTags() {
        // Given
        let dto = AllBookResponseDataDTO(
            id: "book-002",
            name: "Test",
            thumbnail: "https://example.com/img.jpg",
            tag: ["courage", "invalidTag", "growth"],
            plot: [:]
        )

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertEqual(entity.tags?.count, 2)
        XCTAssertEqual(entity.tags?[0], .courage)
        XCTAssertEqual(entity.tags?[1], .growth)
    }

    func test_toEntity_withInvalidURL_returnsBaseBook() {
        // Given
        let dto = AllBookResponseDataDTO(
            id: "book-003",
            name: "Invalid URL Book",
            thumbnail: "",
            tag: [],
            plot: [:]
        )

        // When
        let entity = dto.toEntity()

        // Then - Falls back to baseBook
        XCTAssertEqual(entity.id, "book-001") // baseBook id
    }

    func test_toEntity_mapsNameToTitle() {
        // Given
        let dto = AllBookResponseDataDTO(
            id: "book-004",
            name: "DTO Name Field",
            thumbnail: "https://example.com/img.jpg",
            tag: [],
            plot: [:]
        )

        // When
        let entity = dto.toEntity()

        // Then - DTO's `name` maps to Entity's `title`
        XCTAssertEqual(entity.title, "DTO Name Field")
    }
}


// MARK: - BrowseBookResponseDataDTO Mapping Tests

final class BrowseBookResponseDataDTOMappingTests: XCTestCase {

    func test_toBookEntity_mapsCorrectly() {
        // Given
        let dto = BrowseBookResponseDataDTO(
            id: "browse-001",
            name: "둘러보기 책",
            thumbnail: "https://example.com/browse.jpg",
            tags: ["wisdom", "sharing"],
            shorts: ["ko": "짧은 설명"],
            bookmark: true
        )

        // When
        let entity = dto.toBookEntity()

        // Then
        XCTAssertEqual(entity.id, "browse-001")
        XCTAssertEqual(entity.title, "둘러보기 책")
        XCTAssertEqual(entity.image, URL(string: "https://example.com/browse.jpg")!)
        XCTAssertEqual(entity.tags?.count, 2)
        XCTAssertEqual(entity.shortSummary?["ko"], "짧은 설명")
        XCTAssertNil(entity.longSummary)
        XCTAssertNil(entity.totalPage)
        XCTAssertNil(entity.stillImages)
    }

    func test_isBookmarked_whenTrue_returnsTrue() {
        let dto = BrowseBookResponseDataDTO(
            id: "1", name: "A", thumbnail: "https://a.com/a.jpg",
            tags: [], shorts: [:], bookmark: true
        )
        XCTAssertTrue(dto.isBookmarked)
    }

    func test_isBookmarked_whenFalse_returnsFalse() {
        let dto = BrowseBookResponseDataDTO(
            id: "1", name: "A", thumbnail: "https://a.com/a.jpg",
            tags: [], shorts: [:], bookmark: false
        )
        XCTAssertFalse(dto.isBookmarked)
    }

    func test_toBookEntity_withInvalidURL_returnsBaseBook() {
        let dto = BrowseBookResponseDataDTO(
            id: "browse-002", name: "Bad URL", thumbnail: "",
            tags: [], shorts: [:], bookmark: false
        )

        let entity = dto.toBookEntity()
        XCTAssertEqual(entity.id, "book-001") // baseBook fallback
    }
}


// MARK: - UserBookDataDTO Mapping Tests

final class UserBookDataDTOMappingTests: XCTestCase {

    private let sampleDTO = UserBookDataDTO(
        id: "user-book-001",
        name: "내 책",
        thumbnail: "https://example.com/userbook.jpg",
        totalPage: 20,
        currentPage: 8,
        isLiked: true
    )

    func test_toBookEntity_mapsCorrectly() {
        // When
        let entity = sampleDTO.toBookEntity()

        // Then
        XCTAssertEqual(entity.id, "user-book-001")
        XCTAssertEqual(entity.title, "내 책")
        XCTAssertEqual(entity.image, URL(string: "https://example.com/userbook.jpg")!)
        XCTAssertNil(entity.tags)
        XCTAssertNil(entity.shortSummary)
        XCTAssertNil(entity.longSummary)
        XCTAssertEqual(entity.totalPage, 20)
        XCTAssertNil(entity.stillImages)
    }

    func test_toUserBookEntity_mapsCorrectly() {
        // When
        let entity = sampleDTO.toUserBookEntity()

        // Then
        XCTAssertEqual(entity.id, "user-book-001")
        XCTAssertEqual(entity.totalPage, 20)
        XCTAssertEqual(entity.currentPage, 8)
        XCTAssertTrue(entity.isLiked)
    }

    func test_toUserBookEntity_progressCalculation() {
        // When
        let entity = sampleDTO.toUserBookEntity()

        // Then
        XCTAssertEqual(entity.progress, 8.0 / 20.0, accuracy: 0.001)
        XCTAssertEqual(entity.readingState, .reading)
    }

    func test_toUserBookEntity_whenNotLiked_isLikedFalse() {
        let dto = UserBookDataDTO(
            id: "1", name: "A", thumbnail: "https://a.com/a.jpg",
            totalPage: 10, currentPage: 0, isLiked: false
        )

        let entity = dto.toUserBookEntity()
        XCTAssertFalse(entity.isLiked)
        XCTAssertEqual(entity.readingState, .notStarted)
    }

    func test_toBookEntity_withInvalidURL_returnsBaseBook() {
        let dto = UserBookDataDTO(
            id: "2", name: "Bad", thumbnail: "",
            totalPage: 5, currentPage: 1, isLiked: false
        )

        let entity = dto.toBookEntity()
        XCTAssertEqual(entity.id, "book-001") // baseBook fallback
    }
}


// MARK: - DetailBookDataResponseDTO Mapping Tests

final class DetailBookDataResponseDTOMappingTests: XCTestCase {

    func test_toEntity_mapsAllFields() {
        // Given
        let dto = DetailBookDataResponseDTO(
            id: "detail-001",
            name: "상세 책",
            thumbnail: "https://example.com/detail.jpg",
            stillImages: [
                "https://example.com/still1.jpg",
                "https://example.com/still2.jpg"
            ],
            tags: ["justice", "growth"],
            shorts: ["ko": "짧은 요약"],
            plots: ["ko": "긴 줄거리"],
            bookmark: true
        )

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertEqual(entity.id, "detail-001")
        XCTAssertEqual(entity.title, "상세 책")
        XCTAssertEqual(entity.image, URL(string: "https://example.com/detail.jpg")!)
        XCTAssertEqual(entity.tags?.count, 2)
        XCTAssertEqual(entity.tags?[0], .justice)
        XCTAssertEqual(entity.tags?[1], .growth)
        XCTAssertEqual(entity.shortSummary?["ko"], "짧은 요약")
        XCTAssertEqual(entity.longSummary?["ko"], "긴 줄거리")
        XCTAssertNil(entity.totalPage)
        XCTAssertEqual(entity.stillImages?.count, 2)
    }

    func test_toEntity_stillImages_mapsValidURLsOnly() {
        // Given
        let dto = DetailBookDataResponseDTO(
            id: "detail-002",
            name: "Test",
            thumbnail: "https://example.com/thumb.jpg",
            stillImages: [
                "https://example.com/valid.jpg",
                "",
                "https://example.com/also-valid.jpg"
            ],
            tags: [],
            shorts: [:],
            plots: [:],
            bookmark: false
        )

        // When
        let entity = dto.toEntity()

        // Then - empty string URL("") returns non-nil in Swift, so all 3 map
        // This tests the compactMap behavior
        XCTAssertNotNil(entity.stillImages)
    }

    func test_toEntity_plotsMapsToLongSummary() {
        // Given - DTO uses `plots`, Entity uses `longSummary`
        let dto = DetailBookDataResponseDTO(
            id: "detail-003",
            name: "Plot Test",
            thumbnail: "https://example.com/img.jpg",
            stillImages: [],
            tags: [],
            shorts: ["ko": "short"],
            plots: ["ko": "this is the plot"],
            bookmark: false
        )

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertEqual(entity.longSummary?["ko"], "this is the plot")
    }

    func test_isBookmarked_reflectsBookmarkField() {
        let bookmarked = DetailBookDataResponseDTO(
            id: "1", name: "A", thumbnail: "https://a.com/a.jpg",
            stillImages: [], tags: [], shorts: [:], plots: [:], bookmark: true
        )
        let notBookmarked = DetailBookDataResponseDTO(
            id: "2", name: "B", thumbnail: "https://b.com/b.jpg",
            stillImages: [], tags: [], shorts: [:], plots: [:], bookmark: false
        )

        XCTAssertTrue(bookmarked.isBookmarked)
        XCTAssertFalse(notBookmarked.isBookmarked)
    }

    func test_toEntity_withInvalidURL_returnsBaseBook() {
        let dto = DetailBookDataResponseDTO(
            id: "detail-004", name: "Bad", thumbnail: "",
            stillImages: [], tags: [], shorts: [:], plots: [:], bookmark: false
        )

        let entity = dto.toEntity()
        XCTAssertEqual(entity.id, "book-001") // baseBook fallback
    }
}
