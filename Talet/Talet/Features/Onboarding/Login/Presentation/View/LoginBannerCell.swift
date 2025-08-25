//
//  LoginBannerCell.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit

import SnapKit
import Then


class LoginBannerCell: UICollectionViewCell {
    //MARK: constants
    static let id = "LoginBannerCollectionViewCell"
    
    //MARK: Properties
    private var image = UIImage()
    private var mainString: String = ""
    private var subString: String = ""
    
    //MARK: UI Components
    private lazy var imageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .center
        $0.clipsToBounds = true
        //$0.backgroundColor = .red
    }
    
    private lazy var mainLabel = UILabel().then {
        $0.text = mainString
        $0.textAlignment = .center
        $0.font = .nanum(.headline2)
        $0.textColor = .black
        $0.numberOfLines = 1
    }
    
    private lazy var subLabel = UILabel().then {
        $0.text = subString
        $0.textAlignment = .center
        $0.font = .pretendard(.bodyLong2)
        $0.textColor = .gray400
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
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
    func configure(banner: LoginBannerEntity) {
        imageView.image = banner.image
        mainLabel.text = banner.mainText
        subLabel.text = banner.subText
        layoutIfNeeded()
        print("imageView size: \(imageView.bounds)")
        print("image size: \(imageView.image?.size ?? .zero)")
    }
    
    //MARK: Layout
    private func setLayout() {
        [imageView,
         mainLabel,
         subLabel
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.72)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
}
