//
//  RefreshResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 12/18/25.
//

struct RefreshDataResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

typealias RefreshResponseDTO = BaseResponse<RefreshDataResponseDTO>

extension RefreshDataResponseDTO {
    func toEntity() -> TokenEntity {
        TokenEntity(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
