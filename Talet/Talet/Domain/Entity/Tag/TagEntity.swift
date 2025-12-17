//
//  TagEntity.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

enum TagEntity: CaseIterable, Hashable {
    case courage
    case wisdom
    case goodAndEvil
    case sharing
    case familyLove
    case friendship
    case justice
    case growth
    
    var title: String {
        switch self {
        case .courage: return "용기"
        case .wisdom: return "지혜"
        case .goodAndEvil: return "선과 악"
        case .sharing: return "나눔"
        case .familyLove: return "가족애"
        case .friendship: return "우정"
        case .justice: return "정의"
        case .growth: return "성장"
        }
    }
    
    var subtitle: String {
        switch self {
        case .courage: return "용기 있는 주인공 이야기"
        case .wisdom: return "지혜로운 주인공 이야기"
        case .goodAndEvil: return "선과 악의 갈등 이야기"
        case .sharing: return "나눔을 배우는 이야기"
        case .familyLove: return "가족애를 느끼는 이야기"
        case .friendship: return "우정을 그린 이야기"
        case .justice: return "정의를 지키는 이야기"
        case .growth: return "성장하는 주인공 이야기"
        }
    }
}
