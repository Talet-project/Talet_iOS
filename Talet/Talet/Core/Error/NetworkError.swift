//
//  NetworkError.swift
//  Talet
//
//  Created by 김승희 on 11/17/25.
//

import Foundation


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidRequest
    case noData
    case decodingError
    case unauthorized
    case serverError(Int)
    case apiError(String)
    case unknown
    case detailedError(ErrorResponse)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingError:
            return "데이터 파싱 실패"
        case .unauthorized:
            return "인증 실패 (401)"
        case .serverError(let code):
            return "서버 에러 (\(code))"
        case .apiError(let errorMessage):
            return "api 에러 (\(errorMessage))"
        case .unknown:
            return "알 수 없는 에러"
        case .detailedError(let errorResponse):
            return errorResponse.message ?? "오류가 발생했습니다."
        }
    }
}
