//
//  BookRepositoryJsonImpl.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import Foundation

import RxSwift


final class BookRepositoryJsonImpl: BookRepositoryProtocol {

    // MARK: - Properties
    private var cachedBooks: [BookEntity] = []
    private var userBooks: [UserBookEntity] = []
    private var likedBookIds: Set<String> = []
    private let jsonDecoder = JSONDecoder()

    // MARK: - Init
    init() {
        loadMockData()
    }

    // MARK: - BookRepositoryProtocol
    func fetchBooks() -> Single<[BookEntity]> {
        return .just(cachedBooks)
    }

    func fetchBooks(tag: BookTag) -> Single<[BookEntity]> {
        let filtered = cachedBooks.filter { book in
            book.tag.contains { $0.bookTag == tag }
        }
        return .just(filtered)
    }

    func fetchLikedBooks() -> Single<[BookWithLikeStatus]> {
        let likedBooks = cachedBooks
            .filter { likedBookIds.contains($0.id) }
            .map { BookWithLikeStatus(book: $0, isLiked: true) }
        return .just(likedBooks)
    }

    func fetchBookDetail(bookId: String) -> Single<BookWithLikeStatus> {
        return Single.create { [weak self] single in
            guard let self = self,
                  let book = self.cachedBooks.first(where: { $0.id == bookId }) else {
                single(.failure(NSError(domain: "BookRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Book not found"])))
                return Disposables.create()
            }

            let isLiked = self.likedBookIds.contains(bookId)
            single(.success(BookWithLikeStatus(book: book, isLiked: isLiked)))
            return Disposables.create()
        }
    }
    
    func fetchUserBooks() -> Single<[UserBookEntity]> {
        <#code#>
    }

    func likeBook(bookId: String) -> Single<Void> {
        return Single.create { [weak self] single in
            self?.likedBookIds.insert(bookId)
            single(.success(()))
            return Disposables.create()
        }
    }

    func dislikeBook(bookId: String) -> Single<Void> {
        return Single.create { [weak self] single in
            self?.likedBookIds.remove(bookId)
            single(.success(()))
            return Disposables.create()
        }
    }

    func updateReadingPage(bookId: String, page: Int) -> Single<Void> {
        return .just(())
    }

    // MARK: - Private Methods
    private func loadMockData() {
        loadBooks()
        loadUserBooks()
    }

    private func loadBooks() {
        guard let url = Bundle.main.url(forResource: "books", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? jsonDecoder.decode(MockBooksResponse.self, from: data) else {
            return
        }

        cachedBooks = response.books.compactMap { $0.toEntity() }
    }

    private func loadUserBooks() {
        guard let url = Bundle.main.url(forResource: "user_books", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? jsonDecoder.decode(MockUserBooksResponse.self, from: data) else {
            return
        }

        userBooks = response.userBooks.compactMap { dto in
            guard let book = cachedBooks.first(where: { $0.id == dto.bookId }) else {
                return nil
            }
            
            return UserBookEntity(
                book: book,
                currentPage: dto.currentPage,
                isLiked: dto.isLiked
            )
        }

        likedBookIds = Set(
            response.userBooks
                .filter { $0.isLiked }
                .map { $0.bookId }
        )
    }
}
