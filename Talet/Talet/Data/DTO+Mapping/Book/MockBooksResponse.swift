//
//  MockBooksResponse.swift
//  Talet
//
//  Created by 김승희 on 1/28/26.
//

struct MockBooksResponse: Decodable {
    let books: [BookDTO]
}

struct MockUserBooksResponse: Decodable {
    let userBooks: [UserBookDTO]
}


