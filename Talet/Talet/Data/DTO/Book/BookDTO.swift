//
//  BookDTO.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import Foundation

// MARK: - Book DTO
struct BookDTO: Decodable {
    let id: String
    let title: String
    let image: String
    let tags: [BookTagDTO]
    let shortSummary: [String: String]
    let longSummary: [String: String]
    let totalPage: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case tags
        case shortSummary = "short_summary"
        case longSummary = "long_summary"
        case totalPage = "total_page"
    }
}

// MARK: - BookTag DTO
struct BookTagDTO: Decodable {
    let tag: String
    let foregroundColor: String
    let backgroundColor: String

    enum CodingKeys: String, CodingKey {
        case tag
        case foregroundColor = "foreground_color"
        case backgroundColor = "background_color"
    }
}

// MARK: - UserBook DTO (for liked books)
struct UserBookDTO: Decodable {
    let bookId: String
    let isLiked: Bool

    enum CodingKeys: String, CodingKey {
        case bookId = "book_id"
        case isLiked = "is_liked"
    }
}

// MARK: - Response wrapper for JSON files
struct MockBooksResponse: Decodable {
    let books: [BookDTO]
}

struct MockUserBooksResponse: Decodable {
    let userBooks: [UserBookDTO]

    enum CodingKeys: String, CodingKey {
        case userBooks = "user_books"
    }
}

// MARK: - Mapping to Entity
extension BookTagDTO {
    func toEntity() -> BookTagEntity? {
        guard let bookTag = mapToBookTag(tag) else { return nil }
        return BookTagEntity(
            bookTag: bookTag,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
        )
    }

    private func mapToBookTag(_ value: String) -> BookTag? {
        switch value {
        case "courage": return .courage
        case "wisdom": return .wisdom
        case "good_and_evil": return .goodAndEvil
        case "sharing": return .sharing
        case "family_love": return .familyLove
        case "friendship": return .friendship
        case "justice": return .justice
        case "growth": return .growth
        default: return nil
        }
    }
}

extension BookDTO {
    func toEntity() -> BookEntity? {
        guard let imageURL = URL(string: image) else { return nil }
        return BookEntity(
            id: id,
            title: title,
            image: imageURL,
            tag: tags.compactMap { $0.toEntity() },
            shortSummary: shortSummary,
            longSummary: longSummary,
            totalPage: totalPage
        )
    }
}

extension UserBookDTO {
    func toEntity(with book: BookEntity) -> BookWithLikeStatus {
        BookWithLikeStatus(
            book: book,
            isLiked: isLiked
        )
    }
}
