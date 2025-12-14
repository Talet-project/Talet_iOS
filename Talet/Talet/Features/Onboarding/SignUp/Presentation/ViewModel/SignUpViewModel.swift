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
        let termsAllTapped: Observable<Void>
        let termsServiceTapped: Observable<Void>
        let termsPrivacyTapped: Observable<Void>
        let termsMarketingTapped: Observable<Void>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isCompleteButtonEnabled: Driver<Bool>
                let termsAllChecked: Driver<Bool>
                let termsServiceChecked: Driver<Bool>
                let termsPrivacyChecked: Driver<Bool>
                let termsMarketingChecked: Driver<Bool>
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
        
        // 각 체크박스의 상태 관리
        let termsServiceRelay = BehaviorRelay<Bool>(value: false)
        let termsPrivacyRelay = BehaviorRelay<Bool>(value: false)
        let termsMarketingRelay = BehaviorRelay<Bool>(value: false)
        
        // 개별 체크박스 탭 처리
        input.termsServiceTapped
            .withLatestFrom(termsServiceRelay)
            .map { !$0 }
            .bind(to: termsServiceRelay)
            .disposed(by: disposeBag)
        
        input.termsPrivacyTapped
            .withLatestFrom(termsPrivacyRelay)
            .map { !$0 }
            .bind(to: termsPrivacyRelay)
            .disposed(by: disposeBag)
        
        input.termsMarketingTapped
            .withLatestFrom(termsMarketingRelay)
            .map { !$0 }
            .bind(to: termsMarketingRelay)
            .disposed(by: disposeBag)
        
        // 전체 동의 탭 처리 - 모든 체크박스를 토글
        input.termsAllTapped
            .withLatestFrom(Observable.combineLatest(
                termsServiceRelay,
                termsPrivacyRelay,
                termsMarketingRelay
            ))
            .map { service, privacy, marketing in
                let allChecked = service && privacy && marketing
                return !allChecked
            }
            .subscribe(onNext: { newState in
                termsServiceRelay.accept(newState)
                termsPrivacyRelay.accept(newState)
                termsMarketingRelay.accept(newState)
            })
            .disposed(by: disposeBag)
        
        // 전체 동의 자동 체크 상태 계산
        let termsAllChecked = Observable.combineLatest(
            termsServiceRelay,
            termsPrivacyRelay,
            termsMarketingRelay
        ) { service, privacy, marketing in
            return service && privacy && marketing
        }
            .asDriver(onErrorJustReturn: false)
        
        // 필수 항목 검증
        let isFormValid = Observable.combineLatest(
            input.firstLanguageSelected,
            input.secondLanguageSelected,
            input.nameText,
            input.yearSelected,
            input.monthSelected,
            input.genderSelected,
            termsServiceRelay,
            termsPrivacyRelay
        ) { language1, language2, name, year, month, gender, service, privacy in
            return !name.isEmpty &&
            gender != nil &&
            service &&
            privacy
        }
        
        // 완료 버튼 활성화
        let isCompleteButtonEnabled = isFormValid
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
                termsMarketingRelay
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
                
                let birthDate = "\(yearInt)-\(String(format: "%02d", monthInt))"
                var languages: [LanguageEntity] = []
                
                if let appLang1 = SignUpLanguage.allCases.first(where: { $0.rawValue == language1 }) {
                    languages.append(appLang1.toEntity)
                }
                
                if language2 != "없음",
                   let appLang2 = SignUpLanguage.allCases.first(where: { $0.rawValue == language2 }) {
                    languages.append(appLang2.toEntity)
                }
                
                let request = UserEntity(
                    name: name,
                    birth: birthDate,
                    gender: genderValue.rawValue,
                    languages: languages
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
            termsServiceChecked: termsServiceRelay.asDriver(),
            termsPrivacyChecked: termsPrivacyRelay.asDriver(),
            termsMarketingChecked: termsMarketingRelay.asDriver(),
            signUpSuccess: signUpSuccessRelay.asSignal(),
            errorMessage: errorMessageRelay.asSignal()
        )
    }
}
