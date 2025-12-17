//
//  HomeTabSection.swift
//  Talet
//
//  Created by 윤대성 on 7/24/25.
//

import UIKit

enum HomeTabSection: Hashable {
    case mainBanner(BannerToken)
    case rankingBook(BookDataEntity)
    case readingStatus(ColorItem)
    case allBooksPreview(BookDataEntity)
    case randomViews(TagEntity)
    
    
//    var id: UUID {
//        switch self {
//        case .mainBanner(let token): return token.id
//        case .rankingBook(let token): return token.id
//        case .readingStatus(let item): return item.id
//        case .allBooksPreview(let item): return item.id
//        case .randomViews(let item): return item.id
//        }
//    }

    var color: UIColor {
        switch self {
        case .mainBanner(let item): return .clear
        case .rankingBook(let item): return .clear
        case .readingStatus(let item): return item.color
        case .allBooksPreview(let item): return .clear
        case .randomViews(let item): return .clear
        }
    }
}

struct ColorItem: Hashable {
    let id = UUID()
    let color: UIColor
}

struct BannerToken: Hashable {
    let id = UUID()
}
