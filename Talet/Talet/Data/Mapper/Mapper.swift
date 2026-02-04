//
//  Mapper.swift
//  Talet
//
//  Created by 김승희 on 12/31/25.
//

enum GenderMapper {
    static func fromAPI(_ value: String) throws -> GenderEntity {
        switch value {
        case "여성": return .girl
        case "남성": return .boy
        default: throw NetworkError.decodingError
        }
    }
    
    static func toAPI(_ entity: GenderEntity) -> String {
        switch entity {
        case .girl:
            return "여성"
        case .boy:
            return "남성"
        }
    }
}

enum LanguageMapper {
    static func fromAPI(_ value: String) -> LanguageEntity? {
        switch value.uppercased() {
        case "KOREAN": return .korean
        case "ENGLISH": return .english
        case "CHINESE": return .chinese
        case "JAPANESE": return .japanese
        case "VIETNAMESE": return .vietnamese
        case "THAI": return .thai
        default: return nil
        }
    }
    
    static func toAPI(_ entity: LanguageEntity) -> String {
        switch entity {
        case .korean: return "KOREAN"
        case .english: return "ENGLISH"
        case .chinese: return "CHINESE"
        case .japanese: return "JAPANESE"
        case .vietnamese: return "VIETNAMESE"
        case .thai: return "THAI"
        }
    }
}


enum BookTagMapper {
    static func fromAPI(_ value: String) -> BookTag? {
        switch value {
        case "courage": return .courage
        case "wisdom": return .wisdom
        case "goodAndEvil": return .goodAndEvil
        case "sharing": return .sharing
        case "familyLove": return .familyLove
        case "friendship": return .friendship
        case "justice": return .justice
        case "growth": return .growth
        default: return nil
        }
    }
    
    static func toAPI(_ tag: BookTag) -> String {
        switch tag {
        case .courage: return "courage"
        case .wisdom: return "wisdom"
        case .goodAndEvil: return "goodAndEvil"
        case .sharing: return "sharing"
        case .familyLove: return "familyLove"
        case .friendship: return "friendship"
        case .justice: return "justice"
        case .growth: return "growth"
        }
    }
}
