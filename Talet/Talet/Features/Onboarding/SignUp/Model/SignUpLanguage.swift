//
//  SignUpLanguage.swift
//  Talet
//
//  Created by 김승희 on 12/15/25.
//

enum SignUpLanguage: String, CaseIterable {
    case korean = "🇰🇷 한국어"
    case english = "🇺🇸 English"
    case chinese = "🇨🇳 中文"
    case japanese = "🇯🇵 日本語"
    case vietnamese = "🇻🇳 Tiếng Việt"
    case thai = "🇹🇭 ภาษาไทย"
    
    // UI 표시값 -> Domain Entity 변환
    var toEntity: LanguageEntity {
        switch self {
        case .korean: return .korean
        case .english: return .english
        case .chinese: return .chinese
        case .japanese: return .japanese
        case .vietnamese: return .vietnamese
        case .thai: return .thai
        }
    }
    
    // Domain Entity → UI 표시값 변환
    static func from(_ entity: LanguageEntity) -> SignUpLanguage {
        switch entity {
        case .korean: return .korean
        case .english: return .english
        case .chinese: return .chinese
        case .japanese: return .japanese
        case .vietnamese: return .vietnamese
        case .thai: return .thai
        }
    }
}
