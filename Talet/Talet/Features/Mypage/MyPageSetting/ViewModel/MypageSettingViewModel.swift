//
//  MypageSettingViewModel.swift
//  Talet
//
//  Created by 김승희 on 12/30/25.
//

import Foundation

import RxCocoa
import RxSwift


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
        let logoutSuccess: Signal<Void>
        let withdrawSuccess: Signal<Void>
        let errorMessage: Signal<String>
    }
    
    private let disposeBag = DisposeBag()
    private let useCase: AuthUseCaseProtocol
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let errorRelay = PublishRelay<String>()
        
        let openPrivacyPolicy = input.privacyPolicyTap
            .compactMap { _ -> URL? in
                return URL(string: "https://palrang22.notion.site/2d8ce2dd63a98026a7b3f3ff19f5eda5?pvs=74")
            }
        
        let logoutSuccess = input.logoutTap
            .flatMapLatest { [weak self] _ -> Signal<Void> in
                guard let self else { return .empty() }
                
                return self.useCase.logout()
                    .asSignal(onErrorRecover: { error in
                        let message = (error as? NetworkError)?.errorDescription ?? "로그아웃에 실패했습니다. 해당 현상이 반복될 경우 지원팀에 문의하세요."
                        errorRelay.accept(message)
                        return .empty()
                    })
            }
        
        let withdrawSuccess = input.withdrawTap
            .flatMapLatest { [weak self] _ -> Signal<Void> in
                guard let self else { return .empty() }
                
                return self.useCase.deleteAccount()
                    .asSignal(onErrorRecover: { error in
                        let message = (error as? NetworkError)?.errorDescription ?? "회원 탈퇴에 실패했습니다. 해당 현상이 반복될 경우 지원팀에 문의하세요."
                        errorRelay.accept(message)
                        return .empty()
                    })
            }
        
        
        return Output(
            openPrivacyPolicy: openPrivacyPolicy,
            logoutSuccess: logoutSuccess,
            withdrawSuccess: withdrawSuccess,
            errorMessage: errorRelay.asSignal()
        )
    }
}
