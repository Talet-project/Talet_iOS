//
//  BookRequestDTO.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import Foundation


struct AllBookResponseDataDTO: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let tag: [String]
    let plot: [String: String]
}

typealias AllBookResponseDTO = BaseResponse<[AllBookResponseDataDTO]>

extension AllBookResponseDataDTO {
    func toEntity() -> BookEntity {
        guard let imageURL = URL(string: thumbnail) else { return baseBook }
        return BookEntity(
            id: id,
            title: name,
            image: imageURL,
            tags: tag.compactMap { BookTagMapper.fromAPI($0) },
            shortSummary: nil,
            longSummary: plot,
            totalPage: nil,
            stillImages: nil
        )
    }
}


let baseBook = BookEntity(
    id: "book-001",
    title: "책이름",
    image: URL(string: "https://placehold.co/400x700")!,
    tags: [.courage, .familyLove],
    shortSummary: ["ko": "줄거리"],
    longSummary: ["ko": "긴 줄거리"],
    totalPage: 6,
    stillImages: nil
)
