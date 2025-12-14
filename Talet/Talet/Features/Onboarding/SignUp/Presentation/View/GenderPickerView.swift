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
    
    private let genderImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let nameLabel = UILabel()
    
    private let checkIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .checkIcon
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .gray50
        layer.cornerRadius = 12
        layer.borderWidth = 0
        
        [genderImageView,
         nameLabel,
         checkIcon
        ].forEach { addSubview($0) }
        
        genderImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(60)
            $0.width.equalTo(genderImageView.snp.height).multipliedBy(Float(104)/Float(77))
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(genderImageView.snp.leading)
            $0.top.equalTo(genderImageView.snp.bottom).offset(12)
        }
        
        checkIcon.snp.makeConstraints {
            $0.trailing.equalTo(genderImageView.snp.trailing)
            $0.centerY.equalTo(nameLabel)
            $0.height.equalTo(nameLabel.snp.height)
        }
    }
    
    func configure(image: UIImage?, name: String) {
        genderImageView.image = image
        nameLabel.text = name
        nameLabel.font = .nanum(.headline1)
        nameLabel.textColor = .gray400
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            backgroundColor = .orange500
            checkIcon.isHidden = false
            nameLabel.textColor = .white
        } else {
            backgroundColor = .gray50
            checkIcon.isHidden = true
            nameLabel.textColor = .gray400
        }
    }
}

// Rx Extension
extension Reactive where Base: GenderPickerView {
    var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
