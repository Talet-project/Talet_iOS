//
//  BookTagEntity.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//


struct BookTagEntity {
    let bookTag: BookTag
    let foregroundColor: String
    let backgroundColor: String
}

enum BookTag: String, Encodable {
    case courage = "용기"
    case wisdom = "지혜"
    case goodAndEvil = "선과악"
    case sharing = "나눔"
    case familyLove = "가족애"
    case friendship = "우정"
    case justice = "정의"
    case growth = "성장"
}
