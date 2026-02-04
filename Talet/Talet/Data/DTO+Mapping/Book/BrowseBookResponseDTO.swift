//
//  BrowseBookResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 1/28/26.
//

import Foundation


// 둘러보기
struct BrowseBookResponseDataDTO: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let tags: [String]
    let shorts: [String: String]
    let bookmark: Bool
}

typealias BrowseBookResponseDTO = BaseResponse<[BrowseBookResponseDataDTO]>

extension BrowseBookResponseDataDTO {
    func toBookEntity() -> BookEntity {
        guard let imageURL = URL(string: thumbnail) else { return baseBook }
        return BookEntity(
            id: id,
            title: name,
            image: imageURL,
            tags: tags.compactMap { BookTagMapper.fromAPI($0) },
            shortSummary: shorts,
            longSummary: nil,
            totalPage: nil,
            stillImages: nil
            )
    }
    
    var isBookmarked: Bool {
        bookmark
    }
}
