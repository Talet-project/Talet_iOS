//
//  MypageSettingViewModel.swift
//  Talet
//
//  Created by 김승희 on 12/30/25.
//

import Foundation

import RxSwift
import RxCocoa


protocol MypageSettingViewModelType {
    func transform(input: MypageSettingViewModel.Input) -> MypageSettingViewModel.Output
}

final class MypageSettingViewModel: MypageSettingViewModelType {
    
    struct Input {
        let privacyPolicyTap: Signal<Void>
        let logoutTap: Signal<Void>
        let withdrawTap: Signal<Void>
    }
    
    struct Output {
        let openPrivacyPolicy: Signal<URL>
        let showLogoutConfirm: Signal<Void>
        let showWithdrawConfirm: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    // TODO: UseCase 추가
    // private let authUseCase: AuthUseCaseProtocol
    
    init() {
        // TODO: UseCase 주입
        // self.authUseCase = authUseCase
    }
    
    func transform(input: Input) -> Output {
        let openPrivacyPolicy = input.privacyPolicyTap
            .compactMap { _ -> URL? in
                return URL(string: "https://palrang22.notion.site/2d8ce2dd63a98026a7b3f3ff19f5eda5?pvs=74")
            }
        
        let showLogoutConfirm = input.logoutTap
            .map { _ in () }
        
        let showWithdrawConfirm = input.withdrawTap
            .map { _ in () }
        
        return Output(
            openPrivacyPolicy: openPrivacyPolicy,
            showLogoutConfirm: showLogoutConfirm,
            showWithdrawConfirm: showWithdrawConfirm
        )
    }
    
    // TODO: 로그아웃 기능 구현
    // func logout() -> Single<Void> {
    //     return authUseCase.logout()
    // }
    
    // TODO: 탈퇴 기능 구현
    // func withdraw() -> Single<Void> {
    //     return authUseCase.withdraw()
    // }
}
