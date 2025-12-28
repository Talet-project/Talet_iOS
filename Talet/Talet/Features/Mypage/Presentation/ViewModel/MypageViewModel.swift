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
        let profileGender: Driver<String>
        let profileImageUrl: Driver<String?>
        let errorMessage: Signal<String>
//        let voices: Driver<[VoiceEntity]>
//        let books: Driver<[MyBookEntity]>
    }
    
    private let useCase: MypageUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(useCase: MypageUseCaseProtocol) {
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
            
            profileGender: user
                .map { "\($0.name) | \($0.gender)" }
                .asDriver(onErrorJustReturn: ""),
            
            profileImageUrl: user
                .map { $0.profileImage }
                .asDriver(onErrorJustReturn: nil),
            
            errorMessage: errorMessage
        )
    }
}
