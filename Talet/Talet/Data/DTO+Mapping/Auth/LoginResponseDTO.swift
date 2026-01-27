//
//  LoginResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 11/26/25.
//

struct LoginDataResponseDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let signUpToken: String?
}

typealias LoginResponseDTO = BaseResponse<LoginDataResponseDTO>


extension LoginDataResponseDTO {
    func toEntity() -> LoginResultEntity {
        LoginResultEntity(
            accessToken: accessToken,
            refreshToken: refreshToken,
            signUpToken: signUpToken,
            isSignUpNeeded: signUpToken != nil
        )
    }
}
