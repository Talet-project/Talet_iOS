//
//  VoiceCloningView.swift
//  Talet
//
//  Created by 김승희 on 11/15/25.
//

import UIKit


import RxCocoa
import RxSwift
import SnapKit
import Then


final class VoiceCloningView: UIView {
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let tapMakeVoiceButton = PublishRelay<Void>()
    
    var tapMakeVoice: Signal<Void> {
        tapMakeVoiceButton.asSignal()
    }
    
    // MARK: - UI Components
    private let recordBackground = UIImageView().then {
        $0.image = .voiceCloningViewBackground
        $0.contentMode = .scaleToFill
    }
    
    private let recordIcon = UIImageView().then {
        $0.image = .voiceCloningViewIcon
    }
    
    private let recordTitle = UILabel().then {
        $0.text = "AI 보이스 클로닝"
        $0.textColor = .white
        $0.font = UIFont.nanum(.headline1)
    }
    
    private let recordSubTitle = UILabel().then {
        $0.text = "AI로 내 목소리를 만들어 보세요!"
        $0.textColor = .white
        $0.font = UIFont.pretendard(.body2)
    }
    
    private let makeVoiceButton = UIButton().then {
        $0.setTitle("목소리 만들기", for: .normal)
        $0.setTitleColor(.orange500, for: .normal)
        $0.titleLabel?.font = UIFont.nanum(.headline1)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - bind
    private func bind() {
        makeVoiceButton.rx.tap
            .bind(to: tapMakeVoiceButton)
            .disposed(by: disposeBag)
    }
    
    //MARK: - layout
    private func setLayout() {
        [
            recordBackground,
            recordIcon,
            recordTitle,
            recordSubTitle,
            makeVoiceButton
        ].forEach { addSubview($0)}
        
        recordBackground.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        recordIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(14)
            $0.height.equalToSuperview().multipliedBy(0.27)
            $0.width.equalTo(recordIcon.snp.height)
        }
        
        recordTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(recordIcon.snp.bottom).offset(8)
        }
        
        recordSubTitle.snp.makeConstraints {
            $0.leading.equalTo(recordTitle)
            $0.top.equalTo(recordTitle.snp.bottom).offset(4)
        }
        
        makeVoiceButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalToSuperview().multipliedBy(0.24)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
}
