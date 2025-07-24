//
//  HomeViewController.swift
//  Talet
//
//  Created by 윤대성 on 7/21/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

private enum Section: Int, CaseIterable {
    case mainBanner
    case popularRanking
    case readingStatus
    case allBooksPreview
    case randomViews
    
}

final class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomeTabSection>!
    
    private let bannerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        return view
    }()
    
    private lazy var lootCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBlue
    }
    
    private func configureCollectionView() {
        let layout = createLayout()
        lootCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        lootCollectionView.backgroundColor = .white
        lootCollectionView.register(MainBannerCell.self, forCellWithReuseIdentifier: "MainBannerCell")
        lootCollectionView.register(RankingBookCell.self, forCellWithReuseIdentifier: "RankingBookCell")
        lootCollectionView.register(ReadingStatusCell.self, forCellWithReuseIdentifier: "ReadingStatusCell")
        lootCollectionView.register(BookPreviewCell.self, forCellWithReuseIdentifier: "BookPreviewCell")
        
        view.addSubview(lootCollectionView)
        lootCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                    return HomeLayoutBuilder.defaultSection()
                }
            switch section {
            case .mainBanner:
                return HomeLayoutBuilder.mainBannerSection()
            case .popularRanking:
                return HomeLayoutBuilder.popularSection()
            case .readingStatus:
                return HomeLayoutBuilder.readingStatusSection()
            case .allBooksPreview:
                return HomeLayoutBuilder.themedBooksSection()
            case .randomViews:
                return HomeLayoutBuilder.themedBooksSection()
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, HomeTabSection>(collectionView: lootCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            switch section {
            case .mainBanner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBannerCell", for: indexPath) as! MainBannerCell
                cell.configure(with: itemIdentifier.color)
                return cell
            case .popularRanking:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingBookCell", for: indexPath) as! RankingBookCell
                cell.configure(with: itemIdentifier.color)
                return cell
            case .readingStatus:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadingStatusCell", for: indexPath) as! ReadingStatusCell
                return cell
            case .courageousCharacters, .allBooksPreview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookPreviewCell", for: indexPath) as! BookPreviewCell
                cell.configure(with: itemIdentifier.color)
                return cell
            }
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HomeTabSection>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            let dummyItems: [HomeTabSection]
            switch section {
            case .mainBanner:
                dummyItems = [
                    HomeTabSection.mainBanner(ColorItem(color: .red)),
                    HomeTabSection.mainBanner(ColorItem(color: .blue)),
                    HomeTabSection.mainBanner(ColorItem(color: .green))
                ]
            case .popularRanking:
                dummyItems = [
                    HomeTabSection.rankingBook(ColorItem(color: .orange)),
                    HomeTabSection.rankingBook(ColorItem(color: .purple)),
                    HomeTabSection.rankingBook(ColorItem(color: .brown))
                ]
            case .readingStatus:
                dummyItems = [
                    HomeTabSection.readingStatus(ColorItem(color: .cyan)),
                    HomeTabSection.readingStatus(ColorItem(color: .magenta)),
                    HomeTabSection.readingStatus(ColorItem(color: .yellow))
                ]
            case .allBooksPreview:
                dummyItems = [
                    HomeTabSection.allBooksPreview(ColorItem(color: .gray)),
                    HomeTabSection.allBooksPreview(ColorItem(color: .darkGray)),
                    HomeTabSection.allBooksPreview(ColorItem(color: .lightGray))
                ]
            case .randomViews:
                dummyItems = [
                    HomeTabSection.randomViews(ColorItem(color: .black)),
                    HomeTabSection.randomViews(ColorItem(color: .white)),
                    HomeTabSection.randomViews(ColorItem(color: .systemPink))
                ]
            }
            snapshot.appendItems(dummyItems, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
