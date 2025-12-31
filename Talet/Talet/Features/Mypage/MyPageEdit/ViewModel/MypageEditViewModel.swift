//
//  MyPageEditViewModel.swift
//  Talet
//
//  Created by 김승희 on 12/31/25.
//

import UIKit

import RxCocoa
import RxSwift


final class MypageEditViewModel {
    private let useCase: UserUseCaseProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Input
    struct Input {
        let viewDidLoad: Observable<Void>
        let firstLanguageSelected: Observable<String>
        let secondLanguageSelected: Observable<String>
        let nameText: Observable<String>
        let yearSelected: Observable<String>
        let monthSelected: Observable<String>
        let genderSelected: Observable<GenderEntity>
        let imageSelected: Observable<Data>
        let saveButtonTapped: Observable<Void>
    }

    // MARK: - Output
    struct Output {
        let currentUserInfo: Driver<UserEntity>
        let profileImage: Driver<ProfileImage>
        let isSaveButtonEnabled: Driver<Bool>
        let saveSuccess: Signal<Void>
        let errorMessage: Signal<String>
    }

    // MARK: - Init
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Transform
    func transform(input: Input) -> Output {
        let errorTracker = PublishRelay<String>()
        let saveSuccessTracker = PublishRelay<Void>()
        
        let currentUserInfo = input.viewDidLoad
            .flatMapLatest { [useCase] _ in
                useCase.fetchUserInfo()
                    .asObservable()
                    .catch { _ in
                        errorTracker.accept("사용자 정보를 불러올 수 없습니다.")
                        return Observable.empty()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let profileImage = currentUserInfo
            .map { user in
                ProfileImage(
                    url: user.profileImage,
                    fallback: user.gender.defaultProfileImage
                )
            }
        
        let name = Observable.merge(
            currentUserInfo
                .map { $0.name }
                .asObservable(),
            input.nameText
        )
        
        let language1Entity = input.firstLanguageSelected
            .map { selected -> LanguageEntity? in
                LanguageEntity.allCases
                    .filter { $0 != .korean }
                    .first { $0.displayText == selected }
            }
            .startWith(nil)
        
        let language2Entity = input.secondLanguageSelected
            .map { selected -> LanguageEntity? in
                guard selected != "없음" else { return nil }
                return LanguageEntity.allCases
                    .filter { $0 != .korean }
                    .first { $0.displayText == selected }
            }
            .startWith(nil)
        
        let birthYear = input.yearSelected
            .map { $0.replacingOccurrences(of: "년", with: "") }
            .startWith("")
        
        let birthMonth = input.monthSelected
            .map { raw -> String in
                let m = raw.replacingOccurrences(of: "월", with: "")
                if let intVal = Int(m) {
                    return String(format: "%02d", intVal)
                }
                return m
            }
            .startWith("")
        
        let allInputs = Observable.combineLatest(
            name,
            language1Entity,
            language2Entity,
            birthYear,
            birthMonth,
            input.genderSelected
        )
        
        let isSaveButtonEnabled = allInputs
            .map { name, lang1, _, year, month, gender in
                !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                lang1 != nil &&
                !year.isEmpty &&
                !month.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        input.saveButtonTapped
            .withLatestFrom(allInputs)
            .flatMapLatest { [useCase] name, lang1, lang2, year, month, gender -> Observable<UserEntity> in
                guard
                    let language1 = lang1,
                    !year.isEmpty,
                    !month.isEmpty
                else {
                    errorTracker.accept("모든 필수 항목을 입력해주세요.")
                    return Observable.empty()
                }
                
                var languages: [LanguageEntity] = [language1]
                if let language2 = lang2 { languages.append(language2) }
                
                let birthday = "\(year)-\(month)"
                
                let requestEntity = UserEntity(
                    name: name,
                    birth: birthday,
                    gender: gender,
                    profileImage: nil,
                    languages: languages
                )
                
                return useCase.updateUserInfo(user: requestEntity)
                    .asObservable()
                    .do(onNext: { _ in saveSuccessTracker.accept(()) })
                    .catch { error in
                        if let networkError = error as? NetworkError {
                            errorTracker.accept(networkError.localizedDescription)
                        } else {
                            errorTracker.accept("프로필 수정에 실패했습니다.")
                        }
                        return Observable.empty()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.imageSelected
            .flatMapLatest { [useCase] imageData in
                useCase.updateUserImage(image: imageData)
                    .asObservable()
                    .do(onNext: { _ in saveSuccessTracker.accept(()) })
                    .catch { error in
                        if let networkError = error as? NetworkError {
                            errorTracker.accept(networkError.localizedDescription)
                        } else {
                            errorTracker.accept("프로필 이미지 업로드에 실패했습니다.")
                        }
                        return Observable.empty()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        
        return Output(
            currentUserInfo: currentUserInfo,
            profileImage: profileImage,
            isSaveButtonEnabled: isSaveButtonEnabled,
            saveSuccess: saveSuccessTracker.asSignal(),
            errorMessage: errorTracker.asSignal()
        )
    }
}
