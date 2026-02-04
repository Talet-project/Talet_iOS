//
//  BookRepositoryTests.swift
//  TaletTests
//

import XCTest
import RxSwift
@testable import Talet


final class BookRepositoryTests: XCTestCase {

    var sut: BookRepositoryImpl!
    var mockNetwork: MockNetworkManager!
    var mockTokenManager: MockTokenManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        mockTokenManager = MockTokenManager()
        sut = BookRepositoryImpl(network: mockNetwork, tokenManager: mockTokenManager)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockTokenManager = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - fetchAllBooks

    func test_fetchAllBooks_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "fetchAllBooks")

        sut.fetchAllBooks()
            .subscribe(
                onSuccess: { _ in XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchAllBooks_callsCorrectEndpoint() {
        // Given
        mockTokenManager.accessToken = "token"
        let dto = AllBookResponseDTO(
            success: true,
            message: "ok",
            data: [
                AllBookResponseDataDTO(
                    id: "book-001",
                    name: "Test Book",
                    thumbnail: "https://example.com/img.jpg",
                    tag: ["courage"],
                    plot: ["ko": "Long"]
                )
            ]
        )
        mockNetwork.requestResult = Single.just(dto) as Single<AllBookResponseDTO>

        let expectation = expectation(description: "fetchAllBooks")

        // When
        sut.fetchAllBooks()
            .subscribe(onSuccess: { books in
                XCTAssertEqual(books.count, 1)
                XCTAssertEqual(books.first?.id, "book-001")
                XCTAssertEqual(books.first?.title, "Test Book")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/all")
        XCTAssertEqual(mockNetwork.lastHeaders?["Authorization"], "Bearer token")
    }

    // MARK: - fetchBooks by tag

    func test_fetchBooks_usesCorrectTagEndpoint() {
        // Given - fetchBooks(tag:) doesn't require token
        let dto = AllBookResponseDTO(
            success: true,
            message: "ok",
            data: []
        )
        mockNetwork.requestResult = Single.just(dto) as Single<AllBookResponseDTO>

        let expectation = expectation(description: "fetchByTag")

        // When
        sut.fetchBooks(tag: .friendship)
            .subscribe(onSuccess: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/find/tag/friendship")
    }

    // MARK: - fetchBrowseBooks

    func test_fetchBrowseBooks_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "browse")

        sut.fetchBrowseBooks()
            .subscribe(
                onSuccess: { _ in XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchBrowseBooks_mapsToResponseWithBookmark() {
        // Given
        mockTokenManager.accessToken = "token"
        let dto = BrowseBookResponseDTO(
            success: true,
            message: "ok",
            data: [
                BrowseBookResponseDataDTO(
                    id: "b-1", name: "Browse Book",
                    thumbnail: "https://example.com/img.jpg",
                    tags: ["wisdom"], shorts: ["ko": "Short"], bookmark: true
                )
            ]
        )
        mockNetwork.requestResult = Single.just(dto) as Single<BrowseBookResponseDTO>

        let expectation = expectation(description: "browse")

        // When
        sut.fetchBrowseBooks()
            .subscribe(onSuccess: { responses in
                XCTAssertEqual(responses.count, 1)
                XCTAssertEqual(responses.first?.book.id, "b-1")
                XCTAssertTrue(responses.first?.isBookmarked ?? false)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/look")
    }

    // MARK: - fetchUserBooks

    func test_fetchUserBooks_mapsBookAndProgress() {
        // Given
        mockTokenManager.accessToken = "token"
        let dto = UserBookResponseDTO(
            success: true,
            message: "ok",
            data: [
                UserBookDataDTO(
                    id: "ub-1", name: "My Book",
                    thumbnail: "https://example.com/img.jpg",
                    totalPage: 20, currentPage: 8, isLiked: true
                )
            ]
        )
        mockNetwork.requestResult = Single.just(dto) as Single<UserBookResponseDTO>

        let expectation = expectation(description: "userBooks")

        // When
        sut.fetchUserBooks()
            .subscribe(onSuccess: { responses in
                XCTAssertEqual(responses.count, 1)
                XCTAssertEqual(responses.first?.book.id, "ub-1")
                XCTAssertEqual(responses.first?.progress.currentPage, 8)
                XCTAssertTrue(responses.first?.progress.isLiked ?? false)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/userbook")
    }

    // MARK: - fetchBookDetail

    func test_fetchBookDetail_mapsDetailResponse() {
        // Given
        mockTokenManager.accessToken = "token"
        let dto = DetailBookResponseDTO(
            success: true,
            message: "ok",
            data: DetailBookDataResponseDTO(
                id: "d-1", name: "Detail Book",
                thumbnail: "https://example.com/img.jpg",
                stillImages: ["https://example.com/still1.jpg"],
                tags: ["courage", "growth"],
                shorts: ["ko": "Short"],
                plots: ["ko": "Long plot"],
                bookmark: false
            )
        )
        mockNetwork.requestResult = Single.just(dto) as Single<DetailBookResponseDTO>

        let expectation = expectation(description: "detail")

        // When
        sut.fetchBookDetail(bookId: "d-1")
            .subscribe(onSuccess: { response in
                XCTAssertEqual(response.book.id, "d-1")
                XCTAssertEqual(response.book.title, "Detail Book")
                XCTAssertFalse(response.isBookmarked)
                XCTAssertEqual(response.book.stillImages?.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/find/d-1")
    }

    // MARK: - bookmarkBook

    func test_bookmarkBook_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "bookmark")

        sut.toggleBookmark(bookId: "b-1")
            .subscribe(
                onSuccess: { XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_bookmarkBook_callsCorrectEndpoint() {
        mockTokenManager.accessToken = "token"
        mockNetwork.requestVoidResult = .just(())

        let expectation = expectation(description: "bookmark")

        sut.toggleBookmark(bookId: "b-1")
            .subscribe(onSuccess: { expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/bookmark")
    }

    // MARK: - updateReadingPage

    func test_updateReadingPage_callsCorrectEndpoint() {
        mockTokenManager.accessToken = "token"
        mockNetwork.requestVoidResult = .just(())

        let expectation = expectation(description: "updatePage")

        sut.updateReadingPage(bookId: "b-1", page: 5)
            .subscribe(onSuccess: { expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/book/updatepage")
    }
}
