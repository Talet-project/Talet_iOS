//
//  CustomAlert.swift
//  TaletView
//
//  Created by 김승희 on 11/3/25.
//

import UIKit

import SnapKit
import Then


final class CustomAlert: UIView {
    
    // MARK: - Style
    enum Style {
        case twoButton  // 취소 + 확인
        case oneButton  // 확인만
    }
    
    // MARK: - UI Components
    private let dimmedView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let messageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private let cancelButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(.gray600, for: .normal)
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 12
    }
    
    private let confirmButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .orange500
        $0.layer.cornerRadius = 12
    }
    
    // MARK: - Properties
    private var onConfirm: (() -> Void)?
    private var onCancel: (() -> Void)?
    private let style: Style
    
    // MARK: - Initializer
    init(
        style: Style,
        title: String,
        message: String? = nil,
        cancelButtonTitle: String = "취소",
        confirmButtonTitle: String = "확인",
        onCancel: (() -> Void)? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        self.style = style
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.messageLabel.isHidden = (message == nil || message?.isEmpty == true)
        self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        self.confirmButton.setTitle(confirmButtonTitle, for: .normal)
        self.onCancel = onCancel
        self.onConfirm = onConfirm
        
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupActions() {
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.onCancel?()
            self?.dismiss()
        }, for: .touchUpInside)
        
        confirmButton.addAction(UIAction { [weak self] _ in
            self?.onConfirm?()
            self?.dismiss()
        }, for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dimmedViewTapped() {
        dismiss()
    }
    
    func show(in viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        self.frame = window.bounds
        window.addSubview(self)
        
        // 애니메이션
        self.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(dimmedView)
        addSubview(containerView)
        
        [titleLabel, messageLabel, buttonStackView].forEach {
            containerView.addSubview($0)
        }
        
        // 스타일에 따라 버튼 추가
        switch style {
        case .twoButton:
            buttonStackView.addArrangedSubview(cancelButton)
            buttonStackView.addArrangedSubview(confirmButton)
        case .oneButton:
            buttonStackView.addArrangedSubview(confirmButton)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        buttonStackView.snp.makeConstraints {
            if messageLabel.isHidden {
                $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            } else {
                $0.top.equalTo(messageLabel.snp.bottom).offset(32)
            }
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}
