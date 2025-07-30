//
//  LoginViewController.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit

import SnapKit
import Then


class LoginViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    
    //MARK: UI Components
    private let onboardingView = UIView().then {
        $0.backgroundColor = .clear //임시
    }
    
    private let buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let previewButton = UIButton().then {
        $0.setImage(.loginPreviewButton, for: .normal)
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setImage(.loginAppleButton, for: .normal)
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(.loginKakaoButton, for: .normal)
    }
    
    private let googleLoginButton = UIButton().then {
        $0.setImage(.loginGoogleButton, for: .normal)
    }
    
    //MARK: init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setLayout()
    }
    
    //MARK: Methods
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
        [onboardingView,
         buttonStack
        ].forEach { view.addSubview($0) }
        
        [previewButton,
         appleLoginButton,
         kakaoLoginButton,
         googleLoginButton
        ].forEach { buttonStack.addArrangedSubview($0) }
        
        onboardingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.625)
        }
        
        buttonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(216)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    //MARK: Extensions
}
