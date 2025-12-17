//
//  TagType.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

import UIKit

enum TagType: String, CaseIterable {
    case courage = "용기"
    case wisdom = "지혜"
    case goodAndEvil = "선과 악"
    case sharing = "나눔"
    case familyLove = "가족애"
    case friendship = "우정"
    case justice = "정의"
    case growth = "성장"
    
    var textColor: UIColor {
        switch self {
        case .courage: return UIColor.blue400
        case .wisdom: return UIColor.green500
        case .goodAndEvil: return UIColor.orange500
        case .sharing: return UIColor.purple500
        case .familyLove: return UIColor.pink500
        case .friendship: return UIColor.green500
        case .justice: return UIColor.blue400
        case .growth: return UIColor.pink500
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .courage: return UIColor.blue50
        case .wisdom: return UIColor.green50
        case .goodAndEvil: return UIColor.orange50
        case .sharing: return UIColor.purple50
        case .familyLove: return UIColor.pink50
        case .friendship: return UIColor.green50
        case .justice: return UIColor.blue50
        case .growth: return UIColor.pink50
        }
    }
}
