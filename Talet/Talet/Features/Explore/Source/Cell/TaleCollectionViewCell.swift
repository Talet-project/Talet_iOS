//
//  TaleCollectionViewCell.swift
//  Talet
//
//  Created by 윤대성 on 8/29/25.
//

import UIKit

import SnapKit

final class TaleCollectionViewCell: UICollectionViewCell {
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.image = UIImage.
        return imageView
    }()
    
    private let languageSeleteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let fairyTaleImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.bookTest
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let fairyTaleTitle: UILabel = {
        let label = UILabel()
        label.font = .nanum(.headline2)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "요술 항아리"
        return label
    }()
    
    private let fairyTaleDescription: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bodyLong2)
        label.textColor = .gray500
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "착하고 부지런한 가난한 농부가 마법처럼 물건을 불려내는 요술 항아리를 우연히 얻게되며 펼쳐지는 이야기"
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(.favorite, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 8
        
        button.imageView?.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.center.equalToSuperview()
        }
        
        return button
    }()
    
    private let readButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanum(.body1)
        button.setTitle("읽기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange500
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        [
            fairyTaleImage,
            backgroundImage,
            fairyTaleTitle,
            fairyTaleDescription,
            favoriteButton,
            readButton,
        ].forEach { addSubview($0) }
        
        fairyTaleImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(62)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 190, height: 298))
        }
        
        backgroundImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(favoriteButton.snp.top)
        }
        
        fairyTaleTitle.snp.makeConstraints {
            $0.top.equalTo(fairyTaleImage.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
        }
        
        fairyTaleDescription.snp.makeConstraints {
            $0.top.equalTo(fairyTaleTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-18)
            $0.leading.equalToSuperview().offset(18)
            $0.size.equalTo(CGSize(width: 56, height: 42))
        }
        
        readButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-18)
            $0.leading.equalTo(favoriteButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-18)
            $0.height.equalTo(42)
        }
    }
}
