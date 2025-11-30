//
//  BookResponseRepositoryImpl.swift
//  Talet
//
//  Created by 윤대성 on 12/1/25.
//

import RxSwift

final class BookResponseRepositoryImpl: BookResponseRepository {
    private let network: NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func fetchPopularRankingBooks() -> Single<[BookDataEntity]> {
        return network.request(
            endpoint: "/books/popular",
            method: .get,
            body: nil,
            headers: nil,
            responseType: [BookResponseDTO].self
        ).map { $0.map {$0.toEntity() } }
    }
}
