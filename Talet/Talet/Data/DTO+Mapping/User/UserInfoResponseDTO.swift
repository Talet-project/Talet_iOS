//
//  UserInfoResponseDTO.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import Foundation


struct UserInfoDataResponseDTO: Decodable {
    let profileImage: String?
    let nickname: String
    let gender: String
    let birthday: String
    let languages: [String]
}

typealias UserInfoResponseDTO = BaseResponse<UserInfoDataResponseDTO>

// MARK: - Mapping to Entity
extension UserInfoDataResponseDTO {
    func toEntity() -> UserEntity {        
        UserEntity(
            name: nickname,
            birth: birthday,
            gender: GenderMapper.fromAPI(gender) ?? GenderEntity.boy,
            profileImage: profileImage,
            languages: languages.compactMap(LanguageMapper.fromAPI)
        )
    }
}
