//
//  BookRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import RxSwift


protocol BookRepositoryProtocol {
    func fetchBooks() -> Single<[BookEntity]>
    func fetchBooks(tag: BookTag) -> Single<[BookEntity]>
    func fetchLikedBooks() -> Single<[BookWithLikeStatus]>
    func fetchBookDetail(bookId: String) -> Single<BookWithLikeStatus>
    func fetchUserBooks() -> Single<[UserBookEntity]>
    
    func likeBook(bookId: String) -> Single<Void>
    func dislikeBook(bookId: String) -> Single<Void>
    func updateReadingPage(bookId: String, page: Int) -> Single<Void>
}
