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
        case .girl:
            return "여아"
        case .boy:
            return "남아"
        }
    }
    
    var defaultProfileImage: UIImage {
        switch self {
        case .girl:
            return .profileGirl
        case .boy:
            return .profileBoy
        }
    }
}
