//
//  ExploreViewModel.swift
//  Talet
//
//  Created by 윤대성 on 11/5/25.
//

import UIKit

import RxCocoa
import RxSwift

//struct ExploreModel {
//    let id: String
//    let name: String
//    let thumbnail: String
//    let tags: [String]
////    let shorts: object
//    let bookmark: Bool
//}

protocol ExploreViewModel {
    func transform(input: ExploreViewModelImpl.Input) -> ExploreViewModelImpl.Output
}

final class ExploreViewModelImpl: ExploreViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let items: Driver<[ExploreModel]>
    }
    
    
    func transform(input: Input) -> Output {
        let dummyItems: [ExploreModel] = [
            .init(id: "0", name: "요술", description: "으악", thumbnail: "bookTest", tags: ["지혜","나눔"]),
            .init(id: "1", name: "요술 항아리", description: "으악", thumbnail: "bookTest", tags: ["선과 악"]),
            .init(id: "2", name: "요술 항아리", description: "으악", thumbnail: "bookTest", tags: ["나눔"]),
            .init(id: "3", name: "요술 항아리", description: "으악", thumbnail: "bookTest", tags: ["지혜"]),
            .init(id: "4", name: "요술 항아리", description: "으악", thumbnail: "bookTest", tags: ["선과 악"]),
            .init(id: "5", name: "요술 항아리", description: "으악", thumbnail: "bookTest", tags: ["나눔"])
        ]
        
        return Output(
            items: Driver.just(dummyItems)
        )
    }
    
}
