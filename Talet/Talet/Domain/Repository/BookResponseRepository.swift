//
//  BookResponseRepository.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

import RxSwift

protocol BookResponseRepository {
    func fetchPopularRankingBooks() -> Single<[BookDataEntity]>
}
