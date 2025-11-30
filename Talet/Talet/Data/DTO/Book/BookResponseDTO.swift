//
//  BookResponseDTO.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

import Foundation

struct BookResponseDTO: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let tags: [String]
    let plot: String
}

extension BookResponseDTO {
    func toEntity() -> BookDataEntity {
        return BookDataEntity(
            id: id,
            name: name,
            thumbnailURL: URL(string: thumbnail),
            tags: tags,
            plot: plot
        )
    }
}
