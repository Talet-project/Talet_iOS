//
//  UserBookEntityTests.swift
//  TaletTests
//

import XCTest
@testable import Talet


final class UserBookEntityTests: XCTestCase {

    // MARK: - readingState

    func test_readingState_whenCurrentPageIsZero_returnsNotStarted() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 0, isLiked: false)
        XCTAssertEqual(entity.readingState, .notStarted)
    }

    func test_readingState_whenCurrentPageIsNegative_returnsNotStarted() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: -1, isLiked: false)
        XCTAssertEqual(entity.readingState, .notStarted)
    }

    func test_readingState_whenCurrentPageLessThanTotal_returnsReading() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 5, isLiked: false)
        XCTAssertEqual(entity.readingState, .reading)
    }

    func test_readingState_whenCurrentPageIsOne_returnsReading() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 1, isLiked: false)
        XCTAssertEqual(entity.readingState, .reading)
    }

    func test_readingState_whenCurrentPageEqualsTotal_returnsFinished() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 10, isLiked: false)
        XCTAssertEqual(entity.readingState, .finished)
    }

    func test_readingState_whenCurrentPageExceedsTotal_returnsFinished() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 15, isLiked: false)
        XCTAssertEqual(entity.readingState, .finished)
    }

    // MARK: - progress

    func test_progress_whenHalfway_returns0point5() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 5, isLiked: false)
        XCTAssertEqual(entity.progress, 0.5, accuracy: 0.001)
    }

    func test_progress_whenNotStarted_returnsZero() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 0, isLiked: false)
        XCTAssertEqual(entity.progress, 0.0, accuracy: 0.001)
    }

    func test_progress_whenFinished_returnsOne() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 10, isLiked: false)
        XCTAssertEqual(entity.progress, 1.0, accuracy: 0.001)
    }

    func test_progress_whenOneThird_returnsCorrectValue() {
        let entity = UserBookEntity(id: "1", totalPage: 3, currentPage: 1, isLiked: false)
        XCTAssertEqual(entity.progress, 1.0 / 3.0, accuracy: 0.001)
    }

    // MARK: - Properties

    func test_isLiked_whenTrue_returnsTrue() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 5, isLiked: true)
        XCTAssertTrue(entity.isLiked)
    }

    func test_isLiked_whenFalse_returnsFalse() {
        let entity = UserBookEntity(id: "1", totalPage: 10, currentPage: 5, isLiked: false)
        XCTAssertFalse(entity.isLiked)
    }
}

// MARK: - ReadingState Equatable

extension ReadingState: Equatable {}
