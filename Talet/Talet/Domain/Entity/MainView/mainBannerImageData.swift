//
//  HomeSectionEntity.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

import UIKit

enum HomeSectionEntity: Int, CaseIterable {
    case mainBanner
    case popularRanking
//    case readingStatus
    case allBooksPreview
    case randomViews
}

enum mainBannerImageData: String, CaseIterable {
    case first = "bannerPurple"
    case second = "bannerGreen"
    case third = "bannerBlue"
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
