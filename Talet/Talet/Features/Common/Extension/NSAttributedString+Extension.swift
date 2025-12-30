//
//  NSAttributedString+Extension.swift
//  Talet
//
//  Created by 김승희 on 7/21/25.
//

import UIKit


extension NSAttributedString {
    /// 폰트/행간/자간(-2%)를 적용하는 메서드
    ///
    /// - Parameters:
    ///   - text: 표시할 문자열
    ///   - font: 적용할 UIFont
    ///   - lineHeight: 행간 (nil이면 행간 미적용)
    ///   - letterSpacingMinus2Percent: true면 자간 -2% 적용, false면 미적용
    ///   - textColor: 텍스트 컬러 (옵션)
    /// - Returns: NSAttributedString
    static func styled(
        _ text: String,
        font: UIFont,
        lineHeight: CGFloat? = nil,
        letterSpacingMinus2Percent: Bool = false,
        textColor: UIColor? = nil
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        if let lh = lineHeight {
            paragraph.minimumLineHeight = lh
            paragraph.maximumLineHeight = lh
        }
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph,
            .foregroundColor: textColor ?? .label
        ]
        if letterSpacingMinus2Percent {
            attributes[.kern] = font.pointSize * -0.02
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
}


// 예시 1) 자간 -2%만 적용: label.attributedText = NSAttributedString.styled("text1", font: .pretendard(.body2), letterSpacingMinus2Percent: true)
// 예시 2) 행간 22만 적용: label.attributedText = NSAttributedString.styled("text2", font: .pretendard(.bodyLong1), lineHeight: 22)
// 예시 3) 행간+자간 모두 적용: label.attributedText = NSAttributedString.styled("text3", font: .pretendard(.bodyLong3), lineHeight: 24, letterSpacingMinus2Percent: true)
