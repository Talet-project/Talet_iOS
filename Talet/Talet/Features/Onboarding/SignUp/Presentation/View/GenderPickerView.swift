//
//  GenderPickerView.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


final class GenderPickerView: UIControl {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .gray50
        layer.cornerRadius = 12
        layer.borderWidth = 0
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(12)
        }
    }
    
    func configure(image: UIImage?, name: String) {
        imageView.image = image
        nameLabel.text = name
        nameLabel.font = .pretendard(.body1)
        nameLabel.textColor = .gray600
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            backgroundColor = .orange500
        } else {
            backgroundColor = .gray50
        }
    }
}

// Rx Extension
extension Reactive where Base: GenderPickerView {
    var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
