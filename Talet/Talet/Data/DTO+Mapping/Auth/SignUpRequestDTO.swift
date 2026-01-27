//
//  SignUpRequestDTO.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

struct SignUpRequestDTO: Encodable {
    let name: String
    let birthDate: String
    let gender: String
    let nativeLanguages: [String]
    
    init(from entity: UserEntity) {
        self.name = entity.name
        self.birthDate = entity.birth
        self.gender = GenderMapper.toAPI(entity.gender)
        self.nativeLanguages = entity.languages.compactMap { LanguageMapper.toAPI($0) }
    }
}
