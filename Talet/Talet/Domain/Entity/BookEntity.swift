//
//  BookEntity.swift
//  Talet
//
//  Created by 김승희 on 8/8/25.
//

import Foundation

//필요시수정
struct BookEntity {
    let id: String
    let title: String
    let image: URL
    let shortSummary: String
    let longSummary: String
}

struct MyBookEntity {
    let id: String
    let title: String
    let image: URL
    let readPercentage: Float
    let isBookmarked: Bool
}

// homepage에서 씀 -> ResponseDTO
struct BookDataEntity: Hashable {
    let id: String
    let name: String
    let thumbnailURL: String
    let tags: [String]
    let plot: String
}

// 상세보기 에서 씀 -> BookDetailDTO
struct BookDetailEntity: Hashable {
    let id: String
    let name: String
    let thumbnailURL: String
    let stillImages: [String]
    let tags: [String]
    let shorts: [String: String]
    let plots: [String: String]
    let bookmark: Bool
}

//// 읽고있는책, 북마크, 다읽은책
//enum MyBookState {
//    case reading
//    case bookMarked
//    case alreadyRead
//}
//
//extension MyBookEntity {
//    var bookState: MyBookState? {
//        if readPercentage == 100 {
//            return .alreadyRead
//        } else if readPercentage > 0 {
//            return .reading
//        }
//        if isBookmarked {
//            return .bookMarked
//        }
//    }
//}

// dummyData
let dummyBooks: [MyBookEntity] = [
    MyBookEntity(id: UUID().uuidString, title: "선녀와 나무꾼", image: URL(string: "https://dummy1")!, readPercentage: 0.32, isBookmarked: true),
    MyBookEntity(id: UUID().uuidString, title: "흥부와 놀부", image: URL(string: "https://dummy2")!, readPercentage: 0.74, isBookmarked: false),
    MyBookEntity(id: UUID().uuidString, title: "콩쥐팥쥐", image: URL(string: "https://dummy3")!, readPercentage: 0,  isBookmarked: true),
    MyBookEntity(id: UUID().uuidString, title: "금도끼 은도끼", image: URL(string: "https://dummy4")!, readPercentage: 1, isBookmarked: false),
    MyBookEntity(id: UUID().uuidString, title: "토끼와 거북", image: URL(string: "https://dummy5")!, readPercentage: 0.18, isBookmarked: false),
    MyBookEntity(id: UUID().uuidString, title: "혹부리 영감", image: URL(string: "https://dummy6")!, readPercentage: 0,  isBookmarked: false),
    MyBookEntity(id: UUID().uuidString, title: "별주부전", image: URL(string: "https://dummy7")!, readPercentage: 0.55, isBookmarked: true),
    MyBookEntity(id: UUID().uuidString, title: "방귀쟁이 며느리", image: URL(string: "https://dummy8")!, readPercentage: 1, isBookmarked: false)
]
