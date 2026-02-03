//
//  BookModel.swift
//  Talet
//
//  Created by 김승희 on 2/4/26.
//

struct BrowseBookResponse {
    let book: BookEntity
    let isBookmarked: Bool
}

struct UserBookResponse {
    let book: BookEntity
    let progress: UserBookEntity
}

struct BookDetailResponse {
    let book: BookEntity
    let isBookmarked: Bool
}
