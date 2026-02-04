//
//  UserBookResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 1/28/26.
//

import Foundation


struct UserBookDataDTO: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let totalPage: Int
    let currentPage: Int
    let isLiked: Bool
}

typealias UserBookResponseDTO = BaseResponse<[UserBookDataDTO]>

extension UserBookDataDTO {
    func toBookEntity() -> BookEntity {
        guard let imageURL = URL(string: thumbnail) else { return baseBook }
        
        return BookEntity(
            id: id,
            title: name,
            image: imageURL,
            tags: nil,
            shortSummary: nil,
            longSummary: nil,
            totalPage: totalPage,
            stillImages: nil
        )
    }
    
    func toUserBookEntity() -> UserBookEntity {
        UserBookEntity(
            id: id,
            totalPage: totalPage,
            currentPage: currentPage,
            isLiked: isLiked
        )
    }
}
