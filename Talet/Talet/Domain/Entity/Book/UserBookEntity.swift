//
//  UserBookEntity.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import Foundation


struct UserBookEntity {
    let id: String
    let title: String
    let image: URL
    let totalPage: Int
    let currentPage: Int
    let isLiked: Bool
}


enum ReadingState {
    case notStarted
    case reading
    case finished
}


extension UserBookEntity {
    var readingState: ReadingState {
        guard currentPage > 0 else { return .notStarted }
        return currentPage >= totalPage ? .finished : .reading
    }
    
    var progress: Double {
        Double(currentPage) / Double(totalPage)
    }
}
