//
//  CheckBoxLabelView.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


class CheckBoxLabelView: UIView {
    //MARK: Constants
    
    //MARK: Properties
    var isChecked = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()
    
    private let linkURL: URL?
    
    //MARK: UI Components
    let checkBoxButton = UIButton().then {
        $0.setImage(UIImage.setProfileNotCheckedBox, for: .normal)
        $0.setImage(UIImage.setProfileCheckedBox, for: .selected)
        $0.tintColor = .systemBlue
    }
    
    let titleLabel = UILabel().then {
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
    }
    
    let labelStyleButton = UIButton().then {
        $0.setTitle("내용보기", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = .pretendard(.body2)
        $0.isHidden = true
    }
    
    //MARK: init
    init(text: String, linkURL: URL? = nil) {
        self.linkURL = linkURL
        super.init(frame: .zero)
        
        setLayout()
        titleLabel.text = text
        checkBoxButton.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    @objc private func checkBoxTapped() {
        isChecked.accept(!isChecked.value)
    }
    
    //MARK: Bindings
    func bind() {
        isChecked
            .bind(with: self) { owner, isChecked in
                owner.checkBoxButton.isSelected = isChecked
            }
            .disposed(by: disposeBag)
    }
    
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
