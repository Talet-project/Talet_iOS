//
//  UserInfoResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

struct UserInfoDataResponseDTO: Decodable {
    let profileImage: String?
    let nickname: String
    let gender: String
    let birthday: String
    let languages: [String]
}

typealias UserInfoResponseDTO = BaseResponse<UserInfoDataResponseDTO>
