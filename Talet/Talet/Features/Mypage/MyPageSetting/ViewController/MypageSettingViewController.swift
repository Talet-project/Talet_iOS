//
//  MypageSettingViewController.swift
//  Talet
//
//  Created by 김승희 on 7/30/25.
//

import UIKit
import SafariServices

import RxCocoa
import RxSwift
import SnapKit
import Then


class MypageSettingViewController: UIViewController {
    //MARK: Properties
    private let viewModel: MypageSettingViewModel
    private let disposeBag = DisposeBag()
    
    private let privacyPolicyTapSubject = PublishSubject<Void>()
    private let logoutTapSubject = PublishSubject<Void>()
    private let withdrawTapSubject = PublishSubject<Void>()
    
    //MARK: UI Components
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .singleLine
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.separatorColor = .gray200
        $0.sectionHeaderHeight = 0
        $0.sectionFooterHeight = 0
        $0.isScrollEnabled = false
    }
    
    //MARK: init
    init(viewModel: MypageSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setLayout()
        setupTableView()
        bind()
    }
    
    //MARK: bind
    private func bind() {
        let input = MypageSettingViewModel.Input(
            privacyPolicyTap: privacyPolicyTapSubject.asSignal(onErrorSignalWith: .empty()),
            logoutTap: logoutTapSubject.asSignal(onErrorSignalWith: .empty()),
            withdrawTap: withdrawTapSubject.asSignal(onErrorSignalWith: .empty())
        )
        
        let output = viewModel.transform(input: input)
        
        output.openPrivacyPolicy
            .emit(onNext: { [weak self] url in
                let safariVC = SFSafariViewController(url: url)
                safariVC.modalPresentationStyle = .pageSheet
                self?.present(safariVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.logoutSuccess
            .emit(onNext: { [weak self] in
                self?.navigateToLogin()
            })
            .disposed(by: disposeBag)
        
        output.withdrawSuccess
            .emit(onNext: { [weak self] in
                self?.navigateToLogin()
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .emit(onNext: { [weak self] message in
                self?.showDefaultAlert(title: "오류", message: message)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Methods
    private func setNavigationBar() {
        self.title = "설정"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let backButton = UIButton(type: .system).then {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.left")
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)
            
            $0.configuration = config
            $0.addAction(UIAction(handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }), for: .touchUpInside)
        }
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MypageSettingCell.self, forCellReuseIdentifier: MypageSettingCell.id)
    }
    
    private func showLogoutAlert() {
        showDestructiveAlert(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠습니까?",
            cancelTitle: "취소",
            confirmTitle: "로그아웃",
            onConfirm:  { [weak self] in
                self?.logoutTapSubject.onNext(())
            })
    }

    private func showWithdrawAlert() {
        showDestructiveAlert(
            title: "회원 탈퇴",
            message: "정말 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.",
            cancelTitle: "취소",
            confirmTitle: "탈퇴",
            onConfirm:  { [weak self] in
                self?.withdrawTapSubject.onNext(())
            })
    }
    
    private func navigateToLogin() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.showLoginScreen()
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .gray50
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }
    }
}

//MARK: Extensions
extension MypageSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: MypageSettingCell.id,
                                 for: indexPath) as? MypageSettingCell else {
            return UITableViewCell()
        }
        
        let titles = ["개인정보 처리방침", "로그아웃", "탈퇴하기"]
        cell.configure(title: titles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            privacyPolicyTapSubject.onNext(())
        case 1:
            showLogoutAlert()
        case 2:
            showWithdrawAlert()
        default:
            break
        }
    }
}
