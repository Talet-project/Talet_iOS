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
    
    
    struct Input {
        let loadHomeContent: Observable<Void>
    }

    struct Output {
        let snapshot: Driver<NSDiffableDataSourceSnapshot<Section, HomeTabSection>>
    }

    func transform(input: Input) -> Output {
        let snapshot = input.loadHomeContent
            .map { _ in
                var snapshot = NSDiffableDataSourceSnapshot<Section, HomeTabSection>()
                Section.allCases.forEach { section in
                    snapshot.appendSections([section])
                    let dummyItems: [HomeTabSection] = Self.dummyItems(for: section)
                    snapshot.appendItems(dummyItems, toSection: section)
                }
                return snapshot
            }
            .asDriver(onErrorDriveWith: .empty())

        return Output(snapshot: snapshot)
    }

    private static func dummyItems(for section: Section) -> [HomeTabSection] {
        switch section {
        case .mainBanner:
            let banners: [HomeTabSection] = [
                .mainBanner(ColorItem(color: .red)),
                .mainBanner(ColorItem(color: .blue)),
                .mainBanner(ColorItem(color: .green))
            ]
            var infiniteBanners = banners
            if let first = banners.first, let last = banners.last {
                infiniteBanners.insert(.mainBanner(ColorItem(color: last.color)), at: 0)
                infiniteBanners.append(.mainBanner(ColorItem(color: first.color)))
            }
            print("✅ mainBanner infiniteBanners count: \(infiniteBanners.count)")
            infiniteBanners.enumerated().forEach { index, item in
                print("mainBanner[\(index)] → \(item)")
            }
            return infiniteBanners
        case .popularRanking:
            return [
                .rankingBook(ColorItem(color: .orange)),
                .rankingBook(ColorItem(color: .green)),
                .rankingBook(ColorItem(color: .orange)),
                .rankingBook(ColorItem(color: .green)),
                .rankingBook(ColorItem(color: .orange)),
                .rankingBook(ColorItem(color: .green)),
            ]
        case .readingStatus:
            return [
                .readingStatus(ColorItem(color: .cyan)),
            ]
        case .allBooksPreview:
            return [
                .allBooksPreview(ColorItem(color: .gray)),
                .allBooksPreview(ColorItem(color: .lightGray)),
                .allBooksPreview(ColorItem(color: .gray)),
                .allBooksPreview(ColorItem(color: .lightGray)),
                .allBooksPreview(ColorItem(color: .gray)),
                .allBooksPreview(ColorItem(color: .lightGray)),
            ]
        case .randomViews:
            return [
                .randomViews(ColorItem(color: .systemPink)),
                .randomViews(ColorItem(color: .systemTeal)),
                .randomViews(ColorItem(color: .systemPink)),
                .randomViews(ColorItem(color: .systemTeal)),
                .randomViews(ColorItem(color: .systemPink)),
                .randomViews(ColorItem(color: .systemTeal)),
            ]
        }
    }
}
