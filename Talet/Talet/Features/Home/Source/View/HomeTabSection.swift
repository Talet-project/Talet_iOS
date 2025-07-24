//
//  HomeTabSection.swift
//  Talet
//
//  Created by 윤대성 on 7/24/25.
//

import UIKit

enum HomeTabSection: Hashable {
//    case story(ColorItem)
//    case popular(ColorItem)
//    case comingSoon(ColorItem)
    case mainBanner(ColorItem)
    case rankingBook(ColorItem)
    case readingStatus(ColorItem)
    case allBooksPreview(ColorItem)
    case randomViews(ColorItem)
    
    
    var id: UUID {
        switch self {
        case .mainBanner(let item): return item.id
        case .rankingBook(let item): return item.id
        case .readingStatus(let item): return item.id
        case .allBooksPreview(let item): return item.id
        case .randomViews(let item): return item.id
        }
    }

    var color: UIColor {
        switch self {
        case .mainBanner(let item): return item.color
        case .rankingBook(let item): return item.color
        case .readingStatus(let item): return item.color
        case .allBooksPreview(let item): return item.color
        case .randomViews(let item): return item.color
        }
    }
}

struct ColorItem: Hashable {
    let id = UUID()
    let color: UIColor
}
