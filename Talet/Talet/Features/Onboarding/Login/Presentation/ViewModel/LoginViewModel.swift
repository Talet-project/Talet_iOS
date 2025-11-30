//
//  LoginViewModel.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import Foundation

import RxCocoa
import RxSwift


//protocol LoginViewModelProtocol {
//    associatedtype Input
//    associatedtype Output
//
//    var disposeBag: DisposeBag { get set }
//
//    func transform(input: Input) -> Output
//}

final class LoginViewModel {

    struct Input {
        let appleLoginTapped: Observable<Void>
    }
    
    struct Output {
        let loginSuccess: Signal<LoginResult>
        let errorMessage: Signal<String>
    }
    
    enum LoginResult {
        case success
        case needSignUp(String)
    }
    
    var disposeBag = DisposeBag()
    private let loginUseCase: AuthUseCaseProtocol
    
    init(loginUseCase: AuthUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func transform(input: Input) -> Output {
        let loginResultRelay = PublishRelay<LoginResult>()
        let errorMessageRelay = PublishRelay<String>()
        
        input.appleLoginTapped
            .flatMapLatest { [weak self] _ -> Observable<LoginResultEntity> in
                guard let self else { return .never() }
                return self.loginUseCase.socialLogin(platform: .apple)
                    .asObservable()
                    .catch { error in
                        let message = (error as? NetworkError)?.errorDescription ?? "로그인에 실패했습니다. 자세한 내용은 관리자에게 문의하세요."
                        errorMessageRelay.accept(message)
                        return .empty()
                    }
            }
            .subscribe(
                onNext: { result in
                    if result.isSignUpNeeded {
                        if let signUpToken = result.signUpToken {
                            loginResultRelay.accept(.needSignUp(signUpToken))
                        }
                    } else {
                        loginResultRelay.accept(.success)
                    }
                }
            ).disposed(by: disposeBag)

        return Output(
            loginSuccess: loginResultRelay.asSignal(),
            errorMessage: errorMessageRelay.asSignal()
        )
    }
    
    
}
