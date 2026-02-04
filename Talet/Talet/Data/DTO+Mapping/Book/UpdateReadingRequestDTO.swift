//
//  UpdateReadingRequestDTO.swift
//  Talet
//
//  Created by 김승희 on 2/4/26.
//

struct UpdateReadingRequestDTO: Encodable {
    let bookID: String
    let currentPage: Int
}
