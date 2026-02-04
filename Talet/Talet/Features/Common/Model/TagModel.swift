//
//  TagModel.swift
//  Talet
//
//  Created by 김승희 on 1/28/26.
//

import UIKit


// tag enum 자체는 domain에 정리하고, 뷰에 필요한 것들을 features/common/model에 새롭게 정리했습니다
// tagview는 기존 TagView 사용
struct TagModel {
    let title: String
    let foregroundColor: UIColor
    let backgroundColor: UIColor
}

enum BookTagStyleProvider {
    
    static func style(for tag: BookTag) -> TagModel {
        switch tag {
            
        case .courage:
            return TagModel(
                title: "용기",
                foregroundColor: .blue400,
                backgroundColor: .blue50
            )
            
        case .wisdom:
            return TagModel(
                title: "지혜",
                foregroundColor: .green500,
                backgroundColor: .green50
            )
            
        case .goodAndEvil:
            return TagModel(
                title: "선과 악",
                foregroundColor: .orange500,
                backgroundColor: .orange50
            )
            
        case .sharing:
            return TagModel(
                title: "나눔",
                foregroundColor: .purple500,
                backgroundColor: .purple50
            )
            
        case .familyLove:
            return TagModel(
                title: "가족애",
                foregroundColor: .pink500,
                backgroundColor: .pink50
            )
            
        case .friendship:
            return TagModel(
                title: "우정",
                foregroundColor: .green500,
                backgroundColor: .green50
            )
            
        case .justice:
            return TagModel(
                title: "정의",
                foregroundColor: .blue400,
                backgroundColor: .blue50
            )
            
        case .growth:
            return TagModel(
                title: "성장",
                foregroundColor: .pink500,
                backgroundColor: .pink50
            )
        }
    }
}
