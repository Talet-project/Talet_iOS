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
    private lazy var bannerImageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFit
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
    func configure(banner: LoginBannerModel) {
        bannerImageView.image = banner.image
        mainLabel.text = banner.mainText
        subLabel.text = banner.subText
        layoutIfNeeded()
    }
    
    //MARK: Layout
    private func setLayout() {
        [bannerImageView,
         mainLabel,
         subLabel
        ].forEach { contentView.addSubview($0) }
        
        bannerImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(bannerImageView.snp.width).multipliedBy(Float(302)/Float(390))
        }
        
        mainLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(subLabel.snp.top).offset(-20)
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
