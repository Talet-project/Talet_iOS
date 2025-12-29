//
//  customTypeBadge.swift
//  Talet
//
//  Created by 윤대성 on 7/31/25.
//

import UIKit

import SnapKit

final class CustomTypeBadge: UIView {
    
    private let titleLabel = UILabel()
    
    init(text: String, textColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setLayout(text: text, textColor: textColor, bgColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(text: String, textColor: UIColor, bgColor: UIColor) {
        backgroundColor = bgColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        titleLabel.text = text
        titleLabel.textColor = textColor
        titleLabel.font = .nanum(.label1)
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

