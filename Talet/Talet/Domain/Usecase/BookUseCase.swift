//
//  BookUseCase.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import RxSwift


protocol BookUseCaseProtocol {
    func fetchAllBooks() -> Single<[BookEntity]>
    func fetchBooks(tag: BookTag) -> Single<[BookEntity]>
    func fetchBrowseBooks() -> Single<[BrowseBookResponse]>
    func fetchUserBooks() -> Single<[UserBookResponse]>
    func fetchBookDetail(bookId: String) -> Single<BookDetailResponse>

    func toggleBookmark(bookId: String, isCurrentlyBookmarked: Bool) -> Single<Void>
    func toggleLike(bookId: String, isCurrentlyLiked: Bool) -> Single<Void>
    func updateReadingProgress(bookId: String, page: Int) -> Single<Void>
}


final class BookUseCase: BookUseCaseProtocol {

    private let repository: BookRepositoryProtocol

    init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Fetch

    func fetchAllBooks() -> Single<[BookEntity]> {
        repository.fetchAllBooks()
    }

    func fetchBooks(tag: BookTag) -> Single<[BookEntity]> {
        repository.fetchBooks(tag: tag)
    }

    func fetchBrowseBooks() -> Single<[BrowseBookResponse]> {
        repository.fetchBrowseBooks()
    }

    func fetchUserBooks() -> Single<[UserBookResponse]> {
        repository.fetchUserBooks()
    }

    func fetchBookDetail(bookId: String) -> Single<BookDetailResponse> {
        repository.fetchBookDetail(bookId: bookId)
    }

    // MARK: - Actions

    func toggleBookmark(bookId: String, isCurrentlyBookmarked: Bool) -> Single<Void> {
        if isCurrentlyBookmarked {
            return repository.unbookmarkBook(bookId: bookId)
        } else {
            return repository.bookmarkBook(bookId: bookId)
        }
    }

    func toggleLike(bookId: String, isCurrentlyLiked: Bool) -> Single<Void> {
        if isCurrentlyLiked {
            return repository.unlikeBook(bookId: bookId)
        } else {
            return repository.likeBook(bookId: bookId)
        }
    }

    func updateReadingProgress(bookId: String, page: Int) -> Single<Void> {
        repository.updateReadingPage(bookId: bookId, page: page)
    }
}
