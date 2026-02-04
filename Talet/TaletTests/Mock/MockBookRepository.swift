//
//  MockBookRepository.swift
//  TaletTests
//

import RxSwift
@testable import Talet


final class MockBookRepository: BookRepositoryProtocol {

    // MARK: - Configurable Results

    var allBooksResult: Single<[BookEntity]> = .just([])
    var tagBooksResult: Single<[BookEntity]> = .just([])
    var browseBooksResult: Single<[BrowseBookResponse]> = .just([])
    var userBooksResult: Single<[UserBookResponse]> = .just([])
    var bookDetailResult: Single<BookDetailResponse>!
    var toggleBookmarkResult: Single<Void> = .just(())
    var updatePageResult: Single<Void> = .just(())

    // MARK: - Protocol Methods

    func fetchAllBooks() -> Single<[BookEntity]> {
        return allBooksResult
    }

    func fetchBooks(tag: BookTag) -> Single<[BookEntity]> {
        return tagBooksResult
    }

    func fetchBrowseBooks() -> Single<[BrowseBookResponse]> {
        return browseBooksResult
    }

    func fetchUserBooks() -> Single<[UserBookResponse]> {
        return userBooksResult
    }

    func fetchBookDetail(bookId: String) -> Single<BookDetailResponse> {
        return bookDetailResult
    }

    func toggleBookmark(bookId: String) -> Single<Void> {
        return toggleBookmarkResult
    }

    func updateReadingPage(bookId: String, page: Int) -> Single<Void> {
        return updatePageResult
    }
}
