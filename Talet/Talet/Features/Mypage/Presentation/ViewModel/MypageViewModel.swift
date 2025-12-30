//
//  MypageViewModel.swift
//  Talet
//
//  Created by 김승희 on 8/25/25.
//

import UIKit

import RxCocoa
import RxSwift


class MypageViewModel {
    struct Input {
        let viewDidAppear: Signal<Void>
//        let readingTap: Signal<Void>
//        let bookmarkTap: Signal<Void>
//        let allReadTap: Signal<Void>
    }

    struct Output {
        let profileName: Driver<String>
        let profileInfoText: Driver<String>
        let profileImage: Driver<ProfileImage>
        let errorMessage: Signal<String>
//        let voices: Driver<[VoiceEntity]>
//        let books: Driver<[MyBookEntity]>
    }
    
    private let useCase: UserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        
        let result = input.viewDidAppear
            .asObservable()
            .flatMapLatest { [useCase] in
                useCase.fetchUserInfo()
                    .asObservable()
                    .materialize()
            }
            .share()
        
        let user = result
            .compactMap { $0.element }
        
        let ageText = user
            .map { user in
                guard let age = self.calculateAge(from: user.birth) else {
                    return ""
                }
                return "\(age)세"
            }
            .share()
        
        let profileInfoText = Observable
            .combineLatest(user, ageText)
            .map { user, ageText in
                "\(ageText) | \(user.gender.displayText)"
            }
            .asDriver(onErrorJustReturn: "")
        
        let profileImage = user
            .map { user in
                ProfileImage(
                    url: user.profileImage,
                    fallback: user.gender.defaultProfileImage
                )
            }
            .asDriver(onErrorJustReturn: ProfileImage(url: nil, fallback: .profileBoy))
        
        let errorMessage = result
            .compactMap { $0.error }
            .map { error -> String in
                if case NetworkError.detailedError(let errorResponse) = error {
                    return errorResponse.message ?? "알 수 없는 오류가 발생했습니다."
                }
                return "알 수 없는 오류가 발생했습니다."
            }
            .asSignal(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        
        
        return Output(
            profileName: user
                .map { $0.name }
                .asDriver(onErrorJustReturn: ""),
            
            profileInfoText: profileInfoText,
            
            profileImage: profileImage,
            
            errorMessage: errorMessage
        )
    }
    
    private func calculateAge(from birth: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"

        guard let birthDate = formatter.date(from: birth) else { return nil }

        let calendar = Calendar.current
        let now = Date()

        let birthYear = calendar.component(.year, from: birthDate)
        let currentYear = calendar.component(.year, from: now)

        return currentYear - birthYear + 1
    }
}


struct ProfileImage {
    let url: String?
    let fallback: UIImage
}
