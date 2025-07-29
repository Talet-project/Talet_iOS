//
//  customButton.swift
//  Talet
//
//  Created by 김승희 on 7/29/25.
//

import UIKit

import SnapKit
import Then


/// 사용예시
/// private let doneButton = CustomButton().then { $0.configure(title: "완료", isEnabled: true) }
final class CustomButton: UIButton {
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: configure
    private func configureButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .orange500
        config.baseForegroundColor = .white
        config.title = "버튼"
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        
        self.configuration = config
    }
    
    func configure(title: String, isEnabled: Bool = true) {
        var updatedConfig = self.configuration
        updatedConfig?.title = title
        updatedConfig?.baseBackgroundColor = isEnabled ? .orange500 : .gray100
//        updatedConfig?.baseForegroundColor = isEnabled ? .white : .gray400
        
        let titleColor = isEnabled ? UIColor.white : UIColor.gray400
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.nanum(.display1),
            .foregroundColor: titleColor
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        updatedConfig?.attributedTitle = AttributedString(attributedTitle)
        
        self.configuration = updatedConfig
        self.isEnabled = isEnabled
    }
}
