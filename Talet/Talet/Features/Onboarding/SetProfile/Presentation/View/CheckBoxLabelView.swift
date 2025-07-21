//
//  CheckBoxLabelView.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import SnapKit


class CheckBoxLabelView: UIView {
    //MARK: Constants
    
    //MARK: Properties
    
    //MARK: UI Components
    let checkBoxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.setProfileNotCheckedBox, for: .normal)
        button.setImage(UIImage.setProfileCheckedBox, for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    // 버튼 처리방법 확인후 추후연결
    let labelStyleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("내용보기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.isHidden = true
        return button
    }()
    
    //MARK: init
    init(text: String, linkURL: URL? = nil) {
        super.init(frame: .zero)
        setLayout()
        titleLabel.text = text
        if let url = linkURL {
            labelStyleButton.isHidden = false
        } else {
            labelStyleButton.isHidden = true
        }
        checkBoxButton.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    @objc private func checkBoxTapped() {
        checkBoxButton.isSelected.toggle()
    }
    
    //MARK: Bindings
    
    //MARK: Layout
    private func setLayout() {
        [checkBoxButton,
         titleLabel,
         labelStyleButton].forEach { addSubview($0) }
        
        checkBoxButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        labelStyleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
