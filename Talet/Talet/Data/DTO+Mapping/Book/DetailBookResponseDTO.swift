//
//  DetailBookResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 2/2/26.
//

import Foundation


struct DetailBookDataResponseDTO: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let stillImages: [String]
    let tags: [String]
    let shorts: [String: String]
    let plots: [String: String]
    let bookmark: Bool
}

typealias DetailBookResponseDTO = BaseResponse<DetailBookDataResponseDTO>

extension DetailBookDataResponseDTO {
    func toEntity() -> BookEntity {
        guard let imageURL = URL(string: thumbnail) else { return baseBook }
        return BookEntity(
            id: id,
            title: name,
            image: imageURL,
            tags: tags.compactMap { BookTagMapper.fromAPI($0) },
            shortSummary: shorts,
            longSummary: plots,
            totalPage: nil,
            stillImages: stillImages.compactMap { URL(string: $0) }
        )
    }
    
    var isBookMarked: Bool {
        bookmark
    }
}
