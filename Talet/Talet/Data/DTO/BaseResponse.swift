//
//  BaseResponse.swift
//  Talet
//
//  Created by 김승희 on 11/23/25.
//

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
    let error: ErrorResponse?
}
