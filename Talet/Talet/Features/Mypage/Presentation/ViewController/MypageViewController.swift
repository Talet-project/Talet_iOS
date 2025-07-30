//
//  MypageViewController.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit

import SnapKit
import Then


class MypageViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    var isBoy = true
    var temporaryName = "이수아"
    
    //MARK: UI Components
    private let headerImage = UIImageView().then {
        $0.image = .profileHeaderBG
    }
    
    private let profileIconView = UIView()
    
    private lazy var profileButton = UIButton().then {
//        let profileImage = isBoy ? UIImage.profileBoy : UIImage.profileGirl
//        $0.setImage(profileImage, for: .normal)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.orange400.cgColor
    }
    
    private let profileEditIcon = UIImageView().then {
        $0.image = .profileEditIcon
    }
    
    private lazy var profileName = UILabel().then {
        $0.text = temporaryName
        $0.textColor = .black
        $0.font = .nanum(.headline2)
    }
    
    private lazy var profileGender = UILabel().then {
        let gender = isBoy ? "남아" : "여아"
        $0.text = "이수아 | \(gender)"
        $0.textColor = .gray600
        $0.font = .pretendard(.body1)
    }
    
    private let profileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
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
        setNavigationBar()
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileButton.layer.cornerRadius = profileButton.frame.width * 0.5
    }
    
    //MARK: Methods
    private func setNavigationBar() {
        let leftLabel = UILabel().then {
            $0.text = "마이페이지"
            $0.font = .nanum(.display1)
            $0.textColor = .white
        }
        let leftItem = UIBarButtonItem(customView: leftLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightButton = UIButton().then {
            $0.setImage(.mypageSettingIcon, for: .normal)
            $0.addAction(UIAction(handler: { [weak self] _ in
                let nextVC = MypageSettingViewController()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }), for: .touchUpInside)
        }
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .gray50
        
        [headerImage,
         profileStackView
        ].forEach { view.addSubview($0) }
        
        [profileIconView,
         profileName,
         profileGender
        ].forEach { profileStackView.addArrangedSubview($0) }
        
        [profileButton,
         profileEditIcon
        ].forEach { profileIconView.addSubview($0) }
        
        headerImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        profileIconView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(profileButton)
        }
        
        profileButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(profileButton.snp.width)
            $0.centerX.equalToSuperview()
        }
        
        profileEditIcon.snp.makeConstraints {
            $0.width.equalTo(profileButton).multipliedBy(0.27)
            $0.height.equalTo(profileEditIcon.snp.width)
            $0.right.equalTo(profileButton).offset(profileButton.frame.width * 0.3535)
            $0.bottom.equalTo(profileButton).offset(profileButton.frame.width * 0.3535)
        }
        
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(headerImage).offset(-10)
        }
        
        
    }
    
    //MARK: Extensions
}
