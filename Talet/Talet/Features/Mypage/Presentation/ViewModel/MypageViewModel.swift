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
        let readingTap: Signal<Void>
        let bookmarkTap: Signal<Void>
        let allReadTap: Signal<Void>
    }

    struct Output {
        let profileName: Driver<String>
        let profileGender: Driver<String>
        let voices: Driver<[VoiceEntity]>
        let books: Driver<[MyBookEntity]>
    }

    func transform(input: Input) -> Output {
        let books = BehaviorRelay(value: dummyBooks)

        let filteredBooks = Signal.merge(
            input.readingTap.map { dummyBooks.filter { $0.readPercentage < 1.0 && $0.readPercentage > 0.0 } },
            input.bookmarkTap.map { dummyBooks.filter { $0.isBookmarked } },
            input.allReadTap.map { dummyBooks.filter { $0.readPercentage >= 1.0 } }
        )

        return Output(
            profileName: Driver.just("이수아"),
            profileGender: Driver.just("남아"),
            voices: Driver.just(dummyVoices),
            books: filteredBooks.asDriver(onErrorJustReturn: [])
        )
    }
}
