//
//  UIFont+Extension.swift
//  Talet
//
//  Created by 김승희 on 7/21/25.
//

import UIKit


enum PretendardStyle {
    case body1, body2, bodyLong1, bodyLong2, bodyLong3, label1
}

enum NanumSquareStyle {
    case display1, headline1, headline2, body1, label1, label2
}

//fontName과 fontSize만 적용, 자간과 행간은 NSAttributedString에서 적용
// 기본 weight는 폰트패밀리 직접 적용, fallbackWeight는 폰트 적용 실패시 systemfont의 weight에 적용됨
extension UIFont {
    
    /// 사용 예시: label.font = UIFont.pretendard(.body1)
    static func pretendard(_ style: PretendardStyle) -> UIFont {
        let fontName: String
        let fontSize: CGFloat
        let fallbackWeight: UIFont.Weight
        switch style {
        case .body1:
            fontName = "PretendardVariable-Regular"
            fontSize = 13
            fallbackWeight = .regular

        case .body2:
            fontName = "PretendardVariable-Medium"
            fontSize = 14
            fallbackWeight = .medium

        case .bodyLong1:
            fontName = "PretendardVariable-Regular"
            fontSize = 14
            fallbackWeight = .regular

        case .bodyLong2:
            fontName = "PretendardVariable-Regular"
            fontSize = 15
            fallbackWeight = .regular

        case .bodyLong3:
            fontName = "PretendardVariable-SemiBold"
            fontSize = 16
            fallbackWeight = .semibold

        case .label1:
            fontName = "PretendardVariable-Regular"
            fontSize = 12
            fallbackWeight = .regular
        }

        return UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize, weight: fallbackWeight)
    }
    
    /// 사용 예시: label.font = UIFont.nanum(.display1)
    static func nanum(_ style: NanumSquareStyle) -> UIFont {
        let fontName: String
        let fontSize: CGFloat
        let fallbackWeight: UIFont.Weight

        switch style {
        case .display1:
            fontName = "NanumSquareRoundEB"
            fontSize = 15
            fallbackWeight = .bold

        case .headline1:
            fontName = "NanumSquareRoundEB"
            fontSize = 16
            fallbackWeight = .bold

        case .headline2:
            fontName = "NanumSquareRoundEB"
            fontSize = 20
            fallbackWeight = .bold

        case .body1:
            fontName = "NanumSquareRoundEB"
            fontSize = 14
            fallbackWeight = .bold

        case .label1:
            fontName = "NanumSquareRoundB"
            fontSize = 13
            fallbackWeight = .semibold

        case .label2:
            fontName = "NanumSquareRoundEB"
            fontSize = 16
            fallbackWeight = .bold
        }

        return UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize, weight: fallbackWeight)
    }
}
