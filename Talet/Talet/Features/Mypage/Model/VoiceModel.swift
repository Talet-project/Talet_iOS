//
//  VoiceModel.swift
//  Talet
//
//  Created by 김승희 on 7/31/25.
//

import UIKit

enum VoiceDefaultImage: String, CaseIterable {
    case voiceProfile1
    case voiceProfile2
    case voiceProfile3
    case voiceProfile4
    case voiceProfile5
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}

struct VoiceModel {
    let image: VoiceDefaultImage
    let title: String
    let isPlaying: Bool
    let voiceURL: URL
}
