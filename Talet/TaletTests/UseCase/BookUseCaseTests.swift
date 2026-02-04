//
//  BookUseCaseTests.swift
//  TaletTests
//

import XCTest
import RxSwift
@testable import Talet


final class BookUseCaseTests: XCTestCase {

    var sut: BookUseCase!
    var mockRepository: MockBookRepository!
    var disposeBag: DisposeBag!

    private let testBook = BookEntity(
        id: "book-001",
        title: "Test Book",
        image: URL(string: "https://example.com/image.jpg")!,
        tags: [.courage, .friendship],
        shortSummary: ["ko": "Short"],
        longSummary: ["ko": "Long"],
        totalPage: 10,
        stillImages: nil
    )

    override func setUp() {
        super.setUp()
        mockRepository = MockBookRepository()
        sut = BookUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - fetchAllBooks

    func test_fetchAllBooks_returnsBooks() {
        // Given
        mockRepository.allBooksResult = .just([testBook])

        let expectation = expectation(description: "fetchAllBooks")

        // When
        sut.fetchAllBooks()
            .subscribe(onSuccess: { books in
                // Then
                XCTAssertEqual(books.count, 1)
                XCTAssertEqual(books.first?.id, "book-001")
                XCTAssertEqual(books.first?.title, "Test Book")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchAllBooks_whenEmpty_returnsEmptyArray() {
        // Given
        mockRepository.allBooksResult = .just([])

        let expectation = expectation(description: "fetchAllBooks")

        // When
        sut.fetchAllBooks()
            .subscribe(onSuccess: { books in
                XCTAssertTrue(books.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - fetchBooks by tag

    func test_fetchBooks_withTag_delegatesToRepository() {
        // Given
        mockRepository.tagBooksResult = .just([testBook])

        let expectation = expectation(description: "fetchBooks")

        // When
        sut.fetchBooks(tag: .courage)
            .subscribe(onSuccess: { books in
                XCTAssertEqual(books.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - fetchUserBooks

    func test_fetchUserBooks_returnsUserBookResponses() {
        // Given
        let progress = UserBookEntity(id: "book-001", totalPage: 10, currentPage: 5, isLiked: true)
        let response = UserBookResponse(book: testBook, progress: progress)
        mockRepository.userBooksResult = .just([response])

        let expectation = expectation(description: "fetchUserBooks")

        // When
        sut.fetchUserBooks()
            .subscribe(onSuccess: { responses in
                XCTAssertEqual(responses.count, 1)
                XCTAssertEqual(responses.first?.book.id, "book-001")
                XCTAssertEqual(responses.first?.progress.currentPage, 5)
                XCTAssertEqual(responses.first?.progress.isLiked, true)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - toggleBookmark

    func test_toggleBookmark_returnsSuccess() {
        // Given
        mockRepository.toggleBookmarkResult = .just(())

        let expectation = expectation(description: "toggleBookmark")

        // When
        sut.toggleBookmark(bookId: "book-001")
            .subscribe(onSuccess: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }




    // MARK: - Error propagation

    func test_fetchAllBooks_whenError_propagatesError() {
        // Given
        mockRepository.allBooksResult = .error(NetworkError.serverError(500))

        let expectation = expectation(description: "error")

        // When
        sut.fetchAllBooks()
            .subscribe(
                onSuccess: { _ in XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case NetworkError.serverError(let code) = error else {
                        XCTFail("Wrong error type")
                        return
                    }
                    XCTAssertEqual(code, 500)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }
}
