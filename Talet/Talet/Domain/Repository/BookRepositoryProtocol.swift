//
//  BookRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import RxSwift


protocol BookRepositoryProtocol {
    func fetchAllBooks() -> Single<[BookEntity]>
    func fetchBooks(tag: BookTag) -> Single<[BookEntity]>
    func fetchBrowseBooks() -> Single<[BrowseBookResponse]>
    func fetchUserBooks() -> Single<[UserBookResponse]>
    func fetchBookDetail(bookId: String) -> Single<BookDetailResponse>

    func toggleBookmark(bookId: String) -> Single<Void>
    func updateReadingPage(bookId: String, page: Int) -> Single<Void>
}
