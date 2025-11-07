//
//  ExploreViewModel.swift
//  Talet
//
//  Created by 윤대성 on 11/5/25.
//

import UIKit

import RxCocoa
import RxSwift

struct TaleItem {
    let id: Int
    let title: String
    let description: String
    let thumbnailImageName: String
}

protocol ExploreViewModel {
    func transform(input: ExploreViewModelImpl.Input) -> ExploreViewModelImpl.Output
}

final class ExploreViewModelImpl: ExploreViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let items: Driver<[TaleItem]>
    }
    
    
    func transform(input: Input) -> Output {
        let dummyItems: [TaleItem] = [
            .init(id: 0, title: "요술 항아리", description: "으악", thumbnailImageName: "bookTest"),
            .init(id: 1, title: "요술 항아리", description: "으악", thumbnailImageName: "bookTest"),
            .init(id: 2, title: "요술 항아리", description: "으악", thumbnailImageName: "bookTest"),
            .init(id: 3, title: "요술 항아리", description: "으악", thumbnailImageName: "bookTest"),
            .init(id: 4, title: "요술 항아리", description: "으악", thumbnailImageName: "bookTest"),
            .init(id: 5, title: "요술 항아리", description: "으악", thumbnailImageName: "bookTest")
        ]
        
        return Output(
            items: Driver.just(dummyItems)
        )
    }
    
}
