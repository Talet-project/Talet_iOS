//
//  SetProfileViewModel.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import Foundation

import RxCocoa
import RxSwift


final class SignUpViewModel {
    
    struct Input {
        let firstLanguageSelected: Observable<String>
        let secondLanguageSelected: Observable<String>
        let nameText: Observable<String>
        let yearSelected: Observable<String>
        let monthSelected: Observable<String>
        let genderSelected: Observable<Gender?>
        let termsServiceAgreed: Observable<Bool>
        let termsPrivacyAgreed: Observable<Bool>
        let termsMarketingAgreed: Observable<Bool>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isCompleteButtonEnabled: Driver<Bool>
        let termsAllChecked: Driver<Bool>
        let signUpSuccess: Signal<Void>
        let errorMessage: Signal<String>
    }
    
    enum Gender: String {
        case boy = "남성"
        case girl = "여성"
    }
    
    private let signUpToken: String
    private let signUpUseCase: SignUpUseCaseProtocol
    var disposeBag = DisposeBag()
    
    init(signUpToken: String, signUpUseCase: SignUpUseCaseProtocol) {
        self.signUpToken = signUpToken
        self.signUpUseCase = signUpUseCase
    }
    
    func transform(input: Input) -> Output {
        let signUpSuccessRelay = PublishRelay<Void>()
        let errorMessageRelay = PublishRelay<String>()
        
        // 필수 항목 검증 (language1, 이름, 생년월일, 성별, 필수 약관)
        let isFormValid = Observable.combineLatest(
            input.firstLanguageSelected,
            input.nameText,
            input.yearSelected,
            input.monthSelected,
            input.genderSelected,
            input.termsServiceAgreed,
            input.termsPrivacyAgreed
        ) { language1, name, year, month, gender, service, privacy in
            return !name.isEmpty &&
                   gender != nil &&
                   service &&
                   privacy
        }
        
        // 완료 버튼 활성화
        let isCompleteButtonEnabled = isFormValid
            .asDriver(onErrorJustReturn: false)
        
        // 전체 동의 자동 체크 (필수 2개 + 선택 1개 모두 체크되면)
        let termsAllChecked = Observable.combineLatest(
            input.termsServiceAgreed,
            input.termsPrivacyAgreed,
            input.termsMarketingAgreed
        ) { service, privacy, marketing in
            return service && privacy && marketing
        }
        .asDriver(onErrorJustReturn: false)
        
        // 회원가입 요청
        input.completeButtonTapped
            .withLatestFrom(Observable.combineLatest(
                input.firstLanguageSelected,
                input.secondLanguageSelected,
                input.nameText,
                input.yearSelected,
                input.monthSelected,
                input.genderSelected,
                input.termsMarketingAgreed
            ))
            .flatMapLatest { [weak self] language1, language2, name, year, month, gender, marketing -> Observable<Void> in
                guard let self = self else { return .never() }
                
                guard let yearInt = Int(year.replacingOccurrences(of: "년", with: "")),
                      let monthInt = Int(month.replacingOccurrences(of: "월", with: "")),
                      let genderValue = gender
                else {
                    errorMessageRelay.accept("입력 정보를 확인해주세요.")
                    return .empty()
                }

                let birthDate = "\(yearInt)-\(String(format: "%02d", monthInt))-01"
                var languages: [String] = ["한국어"]

                if language1 != "없음" {
                    languages.append(language1)
                }

                if language2 != "없음" {
                    languages.append(language2)
                }
                
                let request = UserEntity(
                    name: name,
                    birth: birthDate,
                    gender: genderValue.rawValue,
                    languages: [language1, language2]
                )
                
                return self.signUpUseCase
                    .signUp(signUpToken: signUpToken, request: request)
                    .asObservable()
                    .map { _ in () }
                    .catch { error in
                        let message = (error as? NetworkError)?.errorDescription ?? "회원가입에 실패했습니다."
                        errorMessageRelay.accept(message)
                        return .empty()
                    }
            }
            .subscribe(onNext: {
                signUpSuccessRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isCompleteButtonEnabled: isCompleteButtonEnabled,
            termsAllChecked: termsAllChecked,
            signUpSuccess: signUpSuccessRelay.asSignal(),
            errorMessage: errorMessageRelay.asSignal()
        )
    }
}
