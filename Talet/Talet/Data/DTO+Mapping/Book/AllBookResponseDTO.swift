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
    let shortSummary: [String: String]
    let longSummary: [String: String]
    let totalPage: Int
}

typealias AllBookResponseDTO = BaseResponse<AllBookResponseDataDTO>

extension AllBookResponseDataDTO {
    func toEntity() -> BookEntity? {
        guard let imageURL = URL(string: thumbnail) else { return nil }
        return BookEntity(
            id: id,
            title: name,
            image: imageURL,
            tags: tag.compactMap { BookTagMapper.fromAPI($0) },
            shortSummary: shortSummary,
            longSummary: longSummary,
            totalPage: totalPage
        )
    }
}
