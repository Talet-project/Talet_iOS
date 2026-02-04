//
//  UserEntity.swift
//  Talet
//
//  Created by 김승희 on 11/17/25.
//

struct UserEntity {
    let name: String
    let birth: String
    let gender: GenderEntity
    let profileImage: String?
    let languages: [LanguageEntity]
}
