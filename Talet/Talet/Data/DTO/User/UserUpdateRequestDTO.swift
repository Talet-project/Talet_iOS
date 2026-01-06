//
//  UserUpdateRequestDTO.swift
//  Talet
//
//  Created by 김승희 on 12/31/25.
//

struct UserUpdateRequestDTO: Encodable {
    let nickname: String
    let gender: String
    let birthday: String
    let languages: [String]
    
    init(from entity: UserEntity) {
        self.nickname = entity.name
        self.gender = GenderMapper.toAPI(entity.gender)
        self.birthday = entity.birth
        self.languages = entity.languages.map(LanguageMapper.toAPI)
    }
}
