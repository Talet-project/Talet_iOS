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
