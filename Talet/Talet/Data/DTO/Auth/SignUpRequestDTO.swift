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
        self.gender = entity.gender
        self.nativeLanguages = entity.languages.map { language in
            Self.toAPIFormat(language)
        }
    }
    
    // Domain LanguageEntity -> API 형식 변환
    private static func toAPIFormat(_ language: LanguageEntity) -> String {
        switch language {
        case .korean: return "KOREAN"
        case .english: return "ENGLISH"
        case .chinese: return "CHINESE"
        case .japanese: return "JAPANESE"
        case .vietnamese: return "VIETNAMESE"
        case .thai: return "THAI"
        }
    }
}
