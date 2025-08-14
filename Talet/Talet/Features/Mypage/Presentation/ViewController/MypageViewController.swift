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
    let dummyVoices: [VoiceEntity] = [
        VoiceEntity(image: .voiceProfile1, title: "엄마 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy1")!),
        VoiceEntity(image: .voiceProfile2, title: "아빠 목소리", isPlaying: true, voiceURL: URL(string: "https://dummy2")!),
        VoiceEntity(image: .voiceProfile3, title: "수아 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy3")!),
        VoiceEntity(image: .voiceProfile4, title: "할머니 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy4")!),
        VoiceEntity(image: .voiceProfile5, title: "AI 목소리", isPlaying: false, voiceURL: URL(string: "https://dummy5")!)
    ]
    
    let dummyBooks: [MyBookEntity] = [
        MyBookEntity(id: UUID().uuidString, title: "선녀와 나무꾼", image: URL(string: "https://dummy1")!, readPercentage: 0.32, isBookmarked: true),
        MyBookEntity(id: UUID().uuidString, title: "흥부와 놀부", image: URL(string: "https://dummy2")!, readPercentage: 0.74, isBookmarked: false),
        MyBookEntity(id: UUID().uuidString, title: "콩쥐팥쥐", image: URL(string: "https://dummy3")!, readPercentage: 0,  isBookmarked: true),
        MyBookEntity(id: UUID().uuidString, title: "금도끼 은도끼", image: URL(string: "https://dummy4")!, readPercentage: 1, isBookmarked: false),
        MyBookEntity(id: UUID().uuidString, title: "토끼와 거북", image: URL(string: "https://dummy5")!, readPercentage: 0.18, isBookmarked: false),
        MyBookEntity(id: UUID().uuidString, title: "혹부리 영감", image: URL(string: "https://dummy6")!, readPercentage: 0,  isBookmarked: false),
        MyBookEntity(id: UUID().uuidString, title: "별주부전", image: URL(string: "https://dummy7")!, readPercentage: 0.55, isBookmarked: true),
        MyBookEntity(id: UUID().uuidString, title: "방귀쟁이 며느리", image: URL(string: "https://dummy8")!, readPercentage: 1, isBookmarked: false)
    ]

    
    //MARK: Properties
    var isBoy = true
    var temporaryName = "이수아"
    
    //MARK: UI Components
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let headerImage = UIImageView().then {
        $0.image = .profileHeaderBG
    }
    
    private let profileIconView = UIView()
    
    private lazy var profileButton = UIButton().then {
        let profileImage = isBoy ? UIImage.profileBoy : UIImage.profileGirl
        $0.setImage(profileImage, for: .normal)
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
    
    private lazy var voiceSelectView = VoiceSelectView().then {
        $0.setEntity(with: self.dummyVoices)
    }
    
    private lazy var myBookView = MyBookView().then {
        $0.setEntity(with: self.dummyBooks)
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
        let inset = view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = inset
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
            $0.height.equalTo(headerImage).multipliedBy(0.58)
        }
        
        //스크롤뷰 영역
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [voiceSelectView,
         myBookView
        ].forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerImage.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        voiceSelectView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(240)
            $0.centerX.equalToSuperview()
        }
        
        myBookView.snp.makeConstraints {
            $0.top.equalTo(voiceSelectView.snp.bottom).offset(30)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: Extensions
}
