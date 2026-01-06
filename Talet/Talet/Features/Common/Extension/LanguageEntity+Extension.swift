//
//  LanguageEntity+Extension.swift
//  Talet
//
//  Created by 김승희 on 12/31/25.
//

extension LanguageEntity {
    var displayText: String {
        "\(flag) \(localizedName)"
    }
    
    var localizedName: String {
        switch self {
        case .korean: return "한국어"
        case .english: return "English"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .vietnamese: return "Tiếng Việt"
        case .thai: return "ภาษาไทย"
        }
    }
    
    var flag: String {
        switch self {
        case .korean: return "🇰🇷"
        case .english: return "🇺🇸"
        case .chinese: return "🇨🇳"
        case .japanese: return "🇯🇵"
        case .vietnamese: return "🇻🇳"
        case .thai: return "🇹🇭"
        }
    }
}
