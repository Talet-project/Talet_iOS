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
        let randomTag: Driver<TagEntity>
    }
    
    func transform(input: Input) -> Output {
        let content = input.loadHomeContent
            .flatMapLatest { [weak self] _ -> Observable<[BookDataEntity]> in
                guard let self else { return .empty() }
                return self.popularRankingBookUseCase.execute()
                    .asObservable()
                    .catch { error in
                        print("인기 전래동화 받아오기 실패: \(error) -> 더미 값으로 대체")
                        return .just(dummyRankingBooks)
                    }
            }
        
            .map { books -> (all: [BookDataEntity], tag: TagEntity, filtered: [BookDataEntity]) in
                let availableTags = TagEntity.allCases.filter { tag in
                    books.contains { $0.tags.contains(tag.title) }
                }

                guard let pickedTag = availableTags.randomElement() else {
                    return (books, .courage, [])
                }

                let filtered = books.filter { $0.tags.contains(pickedTag.title) }
                return (books, pickedTag, filtered)
            }
            .share(replay: 1)

        let snapshotDriver = content
            .map { payload -> NSDiffableDataSourceSnapshot<HomeSectionEntity, HomeTabSection> in
                var snapshot = NSDiffableDataSourceSnapshot<HomeSectionEntity, HomeTabSection>()

                snapshot.appendSections(HomeSectionEntity.allCases)

                let bannerItems: [HomeTabSection] = mainBannerImageData.allCases.map { _ in
                    HomeTabSection.mainBanner(BannerToken())
                }
                snapshot.appendItems(bannerItems, toSection: .mainBanner)

                let popularItems: [HomeTabSection] = payload.all.map { book in
                    HomeTabSection.rankingBook(book)
                }
                snapshot.appendItems(popularItems, toSection: .popularRanking)

                let allBooksItems: [HomeTabSection] = payload.all.map { book in
                    HomeTabSection.allBooksPreview(book)
                }
                snapshot.appendItems(allBooksItems, toSection: .allBooksPreview)

                let randomItems: [HomeTabSection] = payload.filtered.map { book in
                    HomeTabSection.randomViews(book)
                }
                snapshot.appendItems(randomItems, toSection: .randomViews)

                return snapshot
            }
            .asDriver(onErrorDriveWith: .empty())

        let randomTagDriver = content
            .map { $0.tag }
            .asDriver(onErrorDriveWith: .empty())

        return Output(
            snapshot: snapshotDriver,
            randomTag: randomTagDriver
        )
    }
}
