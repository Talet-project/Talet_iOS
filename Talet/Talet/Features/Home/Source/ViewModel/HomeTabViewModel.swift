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
            return [
                .mainBanner(ColorItem(color: .red)),
                .mainBanner(ColorItem(color: .blue))
            ]
        case .popularRanking:
            return [
                .rankingBook(ColorItem(color: .orange)),
                .rankingBook(ColorItem(color: .green))
            ]
        case .readingStatus:
            return [
                .readingStatus(ColorItem(color: .cyan)),
                .readingStatus(ColorItem(color: .magenta))
            ]
        case .allBooksPreview:
            return [
                .allBooksPreview(ColorItem(color: .gray)),
                .allBooksPreview(ColorItem(color: .lightGray))
            ]
        case .randomViews:
            return [
                .randomViews(ColorItem(color: .systemPink)),
                .randomViews(ColorItem(color: .systemTeal))
            ]
        }
    }
}
