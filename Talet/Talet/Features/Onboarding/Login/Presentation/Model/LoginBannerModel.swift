//
//  LoginBannerModel.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit


// TODO: 이런 uikit import 하는 Presentation Model + data를 두는것 괜찮은걸까요...
struct LoginBannerModel {
    let image: UIImage
    let mainText: String
    let subText: String
}

extension LoginBannerModel {
    static let onboardingBanners: [LoginBannerModel] = [
        LoginBannerModel(
            image: .onboardingFirstImg,
            mainText: "테일릿에 오신 것을 환영해요!",
            subText: "우리 아이가 한국 전래동화를 자연스럽게 이해하고,\n함께 이야기 나눌 수 있는 따뜻한 공간이에요."
        ),
        LoginBannerModel(
            image: .onboardingSecondImg,
            mainText: "부모님의 목소리로 동화를 읽어주세요.",
            subText: "바빠도, 멀리 있어도 괜찮아요. AI가 엄마 아빠의 목소리를 저장해 언제든지 동화를 읽어줄 수 있어요."
        ),
        LoginBannerModel(
            image: .onboardingThirdImg,
            mainText: "동화를 고르는 시간도 즐겁게!",
            subText: "아이의 호기심을 자극하는 둘러보기 기능으로\n재미있는 동화를 쉽게 찾을 수 있어요."
        )
    ]
}


