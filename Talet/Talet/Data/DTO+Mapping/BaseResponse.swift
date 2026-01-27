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

extension BaseResponse {
    func unwrapData() throws -> T {
        if let data = data {
            return data
        }
        if let error = error {
            throw NetworkError.detailedError(error)
        }
        throw NetworkError.unknown
    }
}
