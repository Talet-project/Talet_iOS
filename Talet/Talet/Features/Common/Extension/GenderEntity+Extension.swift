//
//  GenderEntity+Extension.swift
//  Talet
//
//  Created by 김승희 on 12/29/25.
//

import UIKit


extension GenderEntity {
    var displayText: String {
        switch self {
        case .female:
            return "여아"
        case .male:
            return "남아"
        }
    }
    
    var defaultProfileImage: UIImage {
        switch self {
        case .female:
            return .profileGirl
        case .male:
            return .profileBoy
        }
    }
}
