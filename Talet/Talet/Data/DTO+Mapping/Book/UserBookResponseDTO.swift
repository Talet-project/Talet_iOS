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

typealias UserBookDTO = BaseResponse<UserBookDataDTO>

extension UserBookDataDTO {
    func toUserBookEntity(with book: BookEntity) -> UserBookEntity? {
        guard let imageURL = URL(string: thumbnail) else { return nil }
        
        return UserBookEntity(
            id: id,
            title: name,
            image: imageURL,
            totalPage: totalPage,
            currentPage: currentPage,
            isLiked: isLiked
        )
    }
}
