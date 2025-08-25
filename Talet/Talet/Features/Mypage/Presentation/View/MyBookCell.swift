//
//  MyBookCell.swift
//  Talet
//
//  Created by 김승희 on 8/8/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then


class MyBookCell: UICollectionViewCell {
    //MARK: constants
    static let id = "MyBookCell"
    
    //MARK: Properties
    private let mainImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let readPercentView = UIProgressView().then {
        $0.trackTintColor = .gray300
        $0.progress = 0.6
        $0.progressTintColor = .purple500
    }
    
    private let bookTitleLabel = UILabel().then {
        $0.text = "책이름"
        $0.textColor = .gray900
        $0.font = .pretendard(.bodyLong1)
    }
    
    //MARK: UI Components
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: Configure
    func configure(cellModel: MyBookEntity) {
        mainImage.kf.setImage(with: cellModel.image,placeholder: UIImage.bookPlaceHolder ,options: [.cacheOriginalImage])
        bookTitleLabel.text = cellModel.title
        readPercentView.progress = cellModel.readPercentage
    }
    
    //MARK: Layout
    private func setLayout() {
        contentView.backgroundColor = .clear
        
        [mainImage,
         readPercentView,
         bookTitleLabel
        ].forEach { contentView.addSubview($0) }
        
        mainImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        readPercentView.snp.makeConstraints {
            $0.top.equalTo(mainImage.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(mainImage)
            $0.height.equalTo(4)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(readPercentView.snp.bottom).offset(15)
            $0.leading.equalTo(mainImage)
        }
    }
}
