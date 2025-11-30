//
//  PopularRankingBookUseCase.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

import RxSwift

protocol PopularRankingBookUseCase {
    func execute() -> Single<[BookDataEntity]>
}

final class PopularRankingBookUseCaseImpl: PopularRankingBookUseCase {
    private let repository: BookResponseRepository
    
    init(repository: BookResponseRepository) {
        self.repository = repository
    }
    
    func execute() -> Single<[BookDataEntity]> {
        return repository.fetchPopularRankingBooks()
    }
}
