//
//  VoiceSelectCell.swift
//  Talet
//
//  Created by 김승희 on 8/7/25.
//

import UIKit

import SnapKit
import Then


class VoiceSelectCell: UICollectionViewCell {
    //MARK: constants
    static let id = "VoiceSelectCell"
    
    //MARK: Properties
    
    //MARK: UI Components
    private let shadowContainer = UIView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 6
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = .voiceProfile1
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var voiceLabel = UILabel().then {
        $0.text = "목소리명"
        $0.textAlignment = .center
        $0.font = .nanum(.label1)
        $0.textColor = .gray800
        $0.numberOfLines = 1
    }
    
    private lazy var playButton = UIButton().then {
        $0.setImage(.playButton, for: .normal)
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configure(cellModel: VoiceEntity) {
        imageView.image = cellModel.image.image
        voiceLabel.text = cellModel.title
        
        let playButtonImage = cellModel.isPlaying ? UIImage.playButton : UIImage.stopButton
        playButton.setImage(playButtonImage, for: .normal)
    }
    
    //MARK: Layout
    private func setLayout() {
        // 그림자 설정영역
        contentView.addSubview(shadowContainer)
        shadowContainer.addSubview(cardView)
        
        shadowContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [imageView,
         voiceLabel,
         playButton
        ].forEach { cardView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(112)
            $0.height.equalTo(96)
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.width.equalToSuperview().multipliedBy(0.24)
        }
        
        voiceLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(playButton.snp.leading).offset(-5)
        }
    }
}
