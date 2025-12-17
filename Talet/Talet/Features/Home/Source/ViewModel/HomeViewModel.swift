//
//  HomeTabViewModel.swift
//  Talet
//
//  Created by 윤대성 on 7/25/25.
//

import UIKit

import RxCocoa
import RxSwift

protocol HomeViewModel {
    func transform(input: HomeViewModelImpl.Input) -> HomeViewModelImpl.Output
}

final class HomeViewModelImpl: HomeViewModel {
    private let disposeBag = DisposeBag()
    private let popularRankingBookUseCase: PopularRankingBookUseCase
    
    init(PopularRankingBookUseCase: PopularRankingBookUseCase) {
        self.popularRankingBookUseCase = PopularRankingBookUseCase
    }
    
    struct Input {
        let loadHomeContent: Observable<Void>
    }
    
    struct Output {
        let snapshot: Driver<NSDiffableDataSourceSnapshot<HomeSectionEntity, HomeTabSection>>
    }
    
    func transform(input: Input) -> Output {
        let snapshotDriver = input.loadHomeContent
            .flatMapLatest { [weak self] _ -> Observable<[BookDataEntity]> in
                guard let self else { return .empty() }
                return self.popularRankingBookUseCase.execute()
                    .asObservable()
                    .catch { error in
                        print("인기 전래동화 받아오기 실패: \(error) -> 더미 값으로 대체")
                        return .just(dummyRankingBooks)
                    }
            }
            .map { dummyRankingBooks -> NSDiffableDataSourceSnapshot<HomeSectionEntity, HomeTabSection> in
                var snapshot = NSDiffableDataSourceSnapshot<HomeSectionEntity, HomeTabSection>()
                
                snapshot.appendSections(HomeSectionEntity.allCases)
                
                let bannerItems: [HomeTabSection] = mainBannerImageData.allCases.map { _ in
                    HomeTabSection.mainBanner(BannerToken())
                }
                snapshot.appendItems(bannerItems, toSection: .mainBanner)
                
                let popularItems: [HomeTabSection] = dummyRankingBooks.map { book in
                    HomeTabSection.rankingBook(book)
                }
                snapshot.appendItems(popularItems, toSection: .popularRanking)
                
                let allBooksItems: [HomeTabSection] = dummyRankingBooks.map { book in
                    HomeTabSection.allBooksPreview(book)
                }
                snapshot.appendItems(allBooksItems, toSection: .allBooksPreview)
                
                if let randomTagItems = TagEntity.allCases.randomElement() {
                    let filtered = dummyRankingBooks.contains { book in
                        book.tags.contains(randomTagItems.title)
                    }
                    
                    if filtered {
                        let randomItem = HomeTabSection.randomViews(randomTagItems)
                        snapshot.appendItems([randomItem], toSection: .randomViews)
                    } else {
                        snapshot.appendItems([.randomViews(.courage)], toSection: .randomViews)
                    }
                }
                return snapshot
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(snapshot: snapshotDriver)
    }
}
