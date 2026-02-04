//
//  BookEntity.swift
//  Talet
//
//  Created by 김승희 on 8/8/25.
//

import Foundation


struct BookEntity {
    let id: String
    let title: String
    let image: URL
    let tags: [BookTag]?
    let shortSummary: [String:String]?
    let longSummary: [String:String]?
    let totalPage: Int?
    let stillImages: [URL]?
}
