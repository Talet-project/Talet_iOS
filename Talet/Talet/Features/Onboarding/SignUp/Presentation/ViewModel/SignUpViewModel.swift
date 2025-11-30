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
        let FirstLanguageSelected: Observable<String?>
        let SecondLanguageSelected: Observable<String?>
        let nameText: Observable<String>
        let yearSelected: Observable<String?>
        let monthSelected: Observable<String?>
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
            return language1 != nil &&
                   !name.isEmpty &&
                   year != nil &&
                   month != nil &&
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
                
                // 언어 배열 생성
                var languages: [String] = ["한국어"]
                if let lang1 = language1, lang1 != "없음" {
                    languages.append(lang1.uppercased())
                }
                if let lang2 = language2, lang2 != "없음" {
                    languages.append(lang2.uppercased())
                }
                
                // 생년월일 변환
                guard let yearStr = year?.replacingOccurrences(of: "년", with: ""),
                      let monthStr = month?.replacingOccurrences(of: "월", with: ""),
                      let yearInt = Int(yearStr),
                      let monthInt = Int(monthStr),
                      let genderValue = gender else {
                    errorMessageRelay.accept("입력 정보를 확인해주세요.")
                    return .empty()
                }
                
                let birthDate = "\(yearInt)-\(String(format: "%02d", monthInt))-01"
                
                let request = SignUpRequest(
                    signUpToken: self.signUpToken,
                    childName: name,
                    childBirthDate: birthDate,
                    childGender: genderValue.rawValue,
                    languages: languages,
                    marketingAgreed: marketing
                )
                
                return self.signUpUseCase.signUp(request: request)
                    .asObservable()
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
