//
//  LoginViewController.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit

import SnapKit
import Then


class LoginViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    private let bannerList: [LoginBanner] = [
        LoginBanner(image: .onboardingFirstImg, mainText: "테일릿에 오신 것을 환영해요!" , subText: "우리 아이가 한국 전래동화를 자연스럽게 이해하고,\n함께 이야기 나눌 수 있는 따뜻한 공간이에요."),
        LoginBanner(image: .onboardingSecondImg, mainText: "부모님의 목소리로 동화를 읽어주세요." , subText: "바빠도, 멀리 있어도 괜찮아요. AI가 엄마 아빠의 목소리를 저장해 언제든지 동화를 읽어줄 수 있어요."),
        LoginBanner(image: .onboardingThirdImg, mainText: "동화를 고르는 시간도 즐겁게!" , subText: "아이의 호기심을 자극하는 둘러보기 기능으로\n재미있는 동화를 쉽게 찾을 수 있어요.")
    ]
    
    //MARK: UI Components
    private let onboardingStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.sectionInset = .zero
    }
    
    private lazy var loginBannerCollectionView = UICollectionView(frame: .zero,collectionViewLayout: collectionViewLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(LoginBannerCell.self, forCellWithReuseIdentifier: LoginBannerCell.id)
    }
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.currentPage = 0
        $0.currentPageIndicatorTintColor = .orange500
        $0.pageIndicatorTintColor = .gray300
        $0.isEnabled = false
    }
    
    private let buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let previewButton = UIButton().then {
        $0.setImage(.loginPreviewButton, for: .normal)
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setImage(.loginAppleButton, for: .normal)
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(.loginKakaoButton, for: .normal)
    }
    
    private let googleLoginButton = UIButton().then {
        $0.setImage(.loginGoogleButton, for: .normal)
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
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewLayout.itemSize = loginBannerCollectionView.bounds.size
    }
    
    //MARK: Methods
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
        [onboardingStackView,
         buttonStack
        ].forEach { view.addSubview($0) }
        
        [loginBannerCollectionView,
         pageControl
        ].forEach { onboardingStackView.addArrangedSubview($0) }
        
        [previewButton,
         appleLoginButton,
         kakaoLoginButton,
         googleLoginButton
        ].forEach { buttonStack.addArrangedSubview($0) }
        
        loginBannerCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
        
        onboardingStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.625)
        }
        
        buttonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(216)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}


//MARK: Extensions

extension LoginViewController: UICollectionViewDelegate {
    
}

extension LoginViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginBannerCell.id, for: indexPath) as! LoginBannerCell
        cell.configure(banner: bannerList[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = page
    }
}
