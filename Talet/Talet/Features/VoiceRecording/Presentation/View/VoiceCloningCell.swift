//
//  VoiceCloningCell.swift
//  Talet
//
//  Created by 김승희 on 11/15/25.
//

import UIKit

import SnapKit
import Then


final class VoiceCloningCell: UICollectionViewCell {
    
    static let identifier = "VoiceCloningCell"
    
    private let avatarView = UIImageView().then {
        $0.image = UIImage.sampleCharacter
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .black
    }
    
    private let playButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        $0.tintColor = .systemOrange
    }
    
    private let checkBox = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.tintColor = .systemOrange
        $0.isHidden = true
    }
    
    private var isChecked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupShadow()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        [avatarView, titleLabel, playButton, checkBox].forEach { contentView.addSubview($0) }
        
        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(96)
            $0.width.equalTo(112)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(35)
        }
        
        checkBox.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(26)
        }
        
        checkBox.addAction(UIAction { [weak self] _ in
            self?.toggleCheck()
        }, for: .touchUpInside)
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
    }
    
    func configure(title: String, isEditing: Bool) {
        titleLabel.text = title
        playButton.isHidden = isEditing
        checkBox.isHidden = !isEditing
    }
    
    private func toggleCheck() {
        isChecked.toggle()
        let imageName = isChecked ? "checkmark.square.fill" : "square"
        checkBox.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
