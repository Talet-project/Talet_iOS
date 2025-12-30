//
//  LoginViewController.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

//TODO: 화면 이동 및 비즈니스로직 분리
class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    private let banners = LoginBannerModel.onboardingBanners
    
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
    
    private lazy var previewButton = UIButton().then {
        $0.setImage(.loginPreviewButton, for: .normal)
        // 임시 뷰넘김 처리
        $0.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.navigateToMain()
        }), for: .touchUpInside)
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
    init(loginViewModel: LoginViewModel) {
        self.viewModel = loginViewModel
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewLayout.itemSize = loginBannerCollectionView.bounds.size
    }
    
    //MARK: Navigation
    //TODO: 추후 Coordinator로 리팩터링
    private func navigateToMain() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let mainVC = AppDIContainer.shared.makeMainTabBarController()
        window.rootViewController = mainVC
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
    
    private func navigateToSignUp(with signUpToken: String) {
        let signupVC = AppDIContainer.shared.makeSignUpViewController(signUpToken: signUpToken)
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    //MARK: Bindings
    private func bind() {
        let input = LoginViewModel.Input(
            appleLoginTapped: appleLoginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginSuccess
            .emit(with: self) { owner, result in
                switch result {
                case .success:
                    owner.navigateToMain()
                case .needSignUp(let signUpToken):
                    owner.navigateToSignUp(with: signUpToken)
                }
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .emit(with: self) { owner, message in
                owner.showDefaultAlert(title: "에러", message: "로그인에 실패했습니다.")
            }
            .disposed(by: disposeBag)
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
         //kakaoLoginButton,
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
            $0.height.equalTo(160)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}


//MARK: Extensions

extension LoginViewController: UICollectionViewDelegate {
    
}

extension LoginViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginBannerCell.id, for: indexPath) as! LoginBannerCell
        cell.configure(banner: banners[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else { return } 
        
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = page
    }
}
