//
//  BookUseCase.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import RxSwift


protocol BookUseCaseProtocol {
    func fetchAllBooks() -> Single<[BookEntity]>
    func fetchBooksWithTag(tag: BookTag) -> Single<[BookEntity]>
    func fetchBooksWithLike() -> Single<[BookWithLikeStatus]>
    func fetchDetailBook(bookId: String) -> Single<BookWithLikeStatus>
    func fetchUserBooks() -> Single<[UserBookEntity]>
    
    func likeBook(bookId: String) -> Single<Void>
    func dislikeBook(bookId: String) -> Single<Void>
    func updateReadingPage(bookId: String, page: Int) -> Single<Void>
}


final class BookUseCase: BookUseCaseProtocol {
    private let bookRepository: BookRepositoryProtocol
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    // MARK: - Read
    
    func fetchAllBooks() -> Single<[BookEntity]> {
        bookRepository.fetchBooks()
    }
    
    func fetchBooksWithTag(tag: BookTag) -> Single<[BookEntity]> {
        bookRepository.fetchBooks(tag: tag)
    }
    
    func fetchBooksWithLike() -> Single<[BookWithLikeStatus]> {
        bookRepository.fetchLikedBooks()
    }
    
    func fetchDetailBook(bookId: String) -> Single<BookWithLikeStatus> {
        bookRepository.fetchBookDetail(bookId: bookId)
    }
    
    func fetchUserBooks() -> Single<[UserBookEntity]> {
        bookRepository.
    }
    
    // MARK: - Write
    
    func likeBook(bookId: String) -> Single<Void> {
        bookRepository.likeBook(bookId: bookId)
    }
    
    func dislikeBook(bookId: String) -> Single<Void> {
        bookRepository.dislikeBook(bookId: bookId)
    }
    
    func updateReadingPage(bookId: String, page: Int) -> Single<Void> {
        bookRepository.updateReadingPage(bookId: bookId, page: page)
    }
}
