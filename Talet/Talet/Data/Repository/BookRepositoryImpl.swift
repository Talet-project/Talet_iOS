//
//  BookRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import Foundation

import RxSwift


final class BookRepositoryImpl: BookRepositoryProtocol {
    private let network: NetworkManagerProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(
        network: NetworkManagerProtocol = NetworkManager.shared,
        tokenManager: TokenManagerProtocol = TokenManager.shared
    ) {
        self.network = network
        self.tokenManager = tokenManager
    }
    
    func fetchAllBooks() -> RxSwift.Single<[BookEntity]> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.request(
            endpoint: "/book/all",
            method: .get,
            body: nil as String?,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: AllBookResponseDTO.self
        ).map { try $0.unwrapData().map { $0.toEntity() }
        }
    }
    
    func fetchBooks(tag: BookTag) -> RxSwift.Single<[BookEntity]> {
        let tagString = BookTagMapper.toAPI(tag)
        
        return network.request(
            endpoint: "/book/find/tag/\(tagString)",
            method: .get,
            body: nil,
            headers: nil,
            responseType: AllBookResponseDTO.self
        ).map { try $0.unwrapData().map { $0.toEntity() }
        }
    }
    
    func fetchBrowseBooks() -> RxSwift.Single<[BrowseBookResponse]> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.request(
            endpoint: "/book/look",
            method: .get,
            body: nil,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: BrowseBookResponseDTO.self
        ).map {
            try $0.unwrapData().compactMap {
                let book = $0.toBookEntity()
                return BrowseBookResponse(book: book, isBookmarked: $0.isBookmarked)
            }
        }
    }
    
    func fetchUserBooks() -> RxSwift.Single<[UserBookResponse]> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.request(
            endpoint: "/book/userbook",
            method: .get,
            body: nil,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: UserBookResponseDTO.self
        ).map {
            try $0.unwrapData().compactMap {
                let book = $0.toBookEntity()
                let userBook = $0.toUserBookEntity()
                return UserBookResponse(book: book, progress: userBook)
            }
        }
    }
    
    func fetchBookDetail(bookId: String) -> RxSwift.Single<BookDetailResponse> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.request(
            endpoint: "/book/find/\(bookId)",
            method: .get,
            body: nil,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: DetailBookResponseDTO.self
        ).map {
            let dto = try $0.unwrapData()
            let book = dto.toEntity()
            return BookDetailResponse(book: book, isBookmarked: dto.isBookmarked)
        }
    }
    
    func bookmarkBook(bookId: String) -> RxSwift.Single<Void> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.requestVoid(
            endpoint: "/book/bookmark",
            method: .get,
            body: UpdateBookmarkRequestDTO(bookId: bookId),
            headers: ["Authorization": "Bearer \(accessToken)"],
        )
    }
    
    func updateReadingPage(bookId: String, page: Int) -> RxSwift.Single<Void> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.requestVoid(
            endpoint: "/book/updatepage",
            method: .get,
            body: UpdateReadingRequestDTO(bookID: bookId, currentPage: page),
            headers: ["Authorization": "Bearer \(accessToken)"],
        )
    }
}
