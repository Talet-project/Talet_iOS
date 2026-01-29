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
}

extension BaseResponse {
    func unwrapData() throws -> T {
        if let data = data {
            return data
        }
        throw NetworkError.noData
    }
}
