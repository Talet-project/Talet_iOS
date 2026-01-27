//
//  BrowseBookEntity.swift
//  Talet
//
//  Created by 김승희 on 1/27/26.
//

import Foundation


struct BrowseBookEntity {
    let id: String
    let title: String
    let image: URL
    let tags: [BookTag]
    let shortSummary: [String: String]
    let isBookmarked: Bool
}
