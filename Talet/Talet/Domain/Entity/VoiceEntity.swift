//
//  VoiceEntity.swift
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

struct VoiceEntity {
    let image: VoiceDefaultImage
    let title: String
    let isPlaying: Bool
    let voiceURL: URL
}


let dummyVoices: [VoiceEntity] = [
    VoiceEntity(image: .voiceProfile1, title: "엄마 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy1")!),
    VoiceEntity(image: .voiceProfile2, title: "아빠 목소리", isPlaying: true, voiceURL: URL(string: "https://dummy2")!),
    VoiceEntity(image: .voiceProfile3, title: "수아 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy3")!),
    VoiceEntity(image: .voiceProfile4, title: "할머니 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy4")!),
    VoiceEntity(image: .voiceProfile5, title: "AI 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy5")!)
]
