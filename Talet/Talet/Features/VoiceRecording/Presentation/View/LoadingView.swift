//
//  LoadingView.swift
//  TaletView
//
//  Created by 김승희 on 11/12/25.
//

import UIKit

import SnapKit
import Then


final class LoadingView: UIView {
    //MARK: Properties
    
    //MARK: UI Components
    //TODO: 이미지를 애니메이션으로 변경
    private let aiLoadingImage = UIImageView().then {
        $0.image = .aiLoading
        $0.contentMode = .scaleAspectFit
    }
    
    private let aiLoadingLabel = UILabel().then {
        $0.text = "AI가 목소리를 만들고 있어요"
        $0.textColor = .orange
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 1
    }
    
    //MARK: Methods
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()        
    }
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.orange50.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.addSublayer(gradientLayer)
        
        [
            aiLoadingImage,
            aiLoadingLabel
        ].forEach { addSubview($0) }
        
        aiLoadingImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(116.0/390.0)
            $0.height.equalTo(aiLoadingImage.snp.width)
        }
        
        aiLoadingLabel.snp.makeConstraints {
            $0.top.equalTo(aiLoadingImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: Extensions
}
