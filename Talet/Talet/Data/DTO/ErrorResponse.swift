//
//  ErrorResponse.swift
//  Talet
//
//  Created by 김승희 on 11/23/25.
//

struct ErrorResponse: Decodable {
    let code: String?
    let status: Int?
    let message: String?
    let details: [String]?
}
