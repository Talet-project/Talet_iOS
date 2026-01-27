//
//  UserBookEntity.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

struct UserBookEntity {
    let book: BookEntity
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
        return currentPage >= book.totalPage ? .finished : .reading
    }
    
    var progress: Double {
        Double(currentPage) / Double(book.totalPage)
    }
}
