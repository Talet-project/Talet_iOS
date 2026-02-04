//
//  BaseErrorResponse.swift
//  Talet
//
//  Created by 김승희 on 1/29/26.
//

struct BaseErrorResponse: Decodable {
    let success: Bool
    let message: String
    let error: ErrorResponse?
}

extension BaseErrorResponse {
    func unwrapData() throws -> ErrorResponse {
        if let error = error { return error }
        throw NetworkError.unknown
    }
}
