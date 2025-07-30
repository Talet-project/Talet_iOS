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

enum Section: Int, CaseIterable {
    case mainBanner
    case popularRanking
    case readingStatus
    case allBooksPreview
    case randomViews
}

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomeTabSection>!
    private let viewModel: HomeViewModel
    
    private let bannerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        return view
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var lootCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func configureCollectionView() {
        lootCollectionView.backgroundColor = .clear
        lootCollectionView.register(MainBannerCell.self, forCellWithReuseIdentifier: "MainBannerCell")
        lootCollectionView.register(RankingBookCell.self, forCellWithReuseIdentifier: "RankingBookCell")
        lootCollectionView.register(ReadingStatusCell.self, forCellWithReuseIdentifier: "ReadingStatusCell")
        lootCollectionView.register(BookPreviewCell.self, forCellWithReuseIdentifier: "BookPreviewCell")
        lootCollectionView.register(HomeSectionHeaderView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier)
        
        view.addSubview(lootCollectionView)
        lootCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        configureCollectionView()
        configureDataSource()
        bindViewModel()
        lootCollectionView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 1, section: Section.mainBanner.rawValue)
        print("✅ Initial scroll to index 1")
        lootCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
// MARK: - Infinite scroll for mainBanner
    
    private func setLayout() {
        view.backgroundColor = .systemBlue
    }
    
    private func bindViewModel() {
        let input = HomeViewModelImpl.Input(loadHomeContent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.snapshot
            .drive(onNext: { [weak self] snapshot in
                print("✅ Snapshot applied, sections: \(snapshot.sectionIdentifiers)")
                let mainBannerItems = snapshot.itemIdentifiers(inSection: .mainBanner)
                print("mainBanner items count: \(mainBannerItems.count)")
                mainBannerItems.enumerated().forEach { idx, item in
                    print("snapshot mainBanner[\(idx)] → \(item)")
                }
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
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
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Invalid section at index \(indexPath.section)")
            }
            
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
            case .allBooksPreview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookPreviewCell", for: indexPath) as! BookPreviewCell
                cell.configure(with: itemIdentifier.color)
                return cell
            case .randomViews:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookPreviewCell", for: indexPath) as! BookPreviewCell
                cell.configure(with: itemIdentifier.color)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! HomeSectionHeaderView
            
            if let section = Section(rawValue: indexPath.section) {
                switch section {
                case .mainBanner: return nil
                case .popularRanking: header.configure(title: "친구들이 좋아하는 인기 전래동화")
                case .readingStatus: return nil
                case .allBooksPreview: header.configure(title: "전체 책 보기")
                case .randomViews: header.configure(title: "용기 → 용기있는 주인공 이야기")
                }
            }
            return header
        }
    }
    
//    private func applyInitialSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, HomeTabSection>()
//        Section.allCases.forEach { section in
//            snapshot.appendSections([section])
//            let dummyItems: [HomeTabSection]
//            switch section {
//            case .mainBanner:
//                dummyItems = [
//                    HomeTabSection.mainBanner(ColorItem(color: .red)),
//                    HomeTabSection.mainBanner(ColorItem(color: .blue)),
//                    HomeTabSection.mainBanner(ColorItem(color: .green))
//                ]
//            case .popularRanking:
//                dummyItems = [
//                    HomeTabSection.rankingBook(ColorItem(color: .orange)),
//                    HomeTabSection.rankingBook(ColorItem(color: .purple)),
//                    HomeTabSection.rankingBook(ColorItem(color: .brown)),
//                    HomeTabSection.rankingBook(ColorItem(color: .orange)),
//                    HomeTabSection.rankingBook(ColorItem(color: .purple)),
//                    HomeTabSection.rankingBook(ColorItem(color: .orange)),
//                    HomeTabSection.rankingBook(ColorItem(color: .purple)),
//                    HomeTabSection.rankingBook(ColorItem(color: .brown)),
//                    HomeTabSection.rankingBook(ColorItem(color: .orange)),
//                    HomeTabSection.rankingBook(ColorItem(color: .purple)),
//                ]
//            case .readingStatus:
//                dummyItems = [
//                    HomeTabSection.readingStatus(ColorItem(color: .red)),
//                ]
//            case .allBooksPreview:
//                dummyItems = [
//                    HomeTabSection.allBooksPreview(ColorItem(color: .gray)),
//                    HomeTabSection.allBooksPreview(ColorItem(color: .darkGray)),
//                    HomeTabSection.allBooksPreview(ColorItem(color: .lightGray)),
//                    HomeTabSection.allBooksPreview(ColorItem(color: .gray)),
//                    HomeTabSection.allBooksPreview(ColorItem(color: .darkGray)),
//                    HomeTabSection.allBooksPreview(ColorItem(color: .lightGray))
//                    
//                ]
//            case .randomViews:
//                dummyItems = [
//                    HomeTabSection.randomViews(ColorItem(color: .black)),
//                    HomeTabSection.randomViews(ColorItem(color: .white)),
//                    HomeTabSection.randomViews(ColorItem(color: .systemPink)),
//                    HomeTabSection.randomViews(ColorItem(color: .black)),
//                    HomeTabSection.randomViews(ColorItem(color: .white)),
//                    HomeTabSection.randomViews(ColorItem(color: .systemPink))
//                ]
//            }
//            snapshot.appendItems(dummyItems, toSection: section)
//        }
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleItems = lootCollectionView.indexPathsForVisibleItems.sorted()
        guard let currentIndexPath = visibleItems.first,
              currentIndexPath.section == Section.mainBanner.rawValue else { return }
        
        let totalCount = dataSource.snapshot().itemIdentifiers(inSection: .mainBanner).count
        print("✅ Scrolled to index: \(currentIndexPath.item), totalCount: \(totalCount)")
        if currentIndexPath.item == 0 {
            print("⬅️ Left edge reached → jump to \(totalCount - 2)")
            let target = IndexPath(item: totalCount - 2, section: Section.mainBanner.rawValue)
            lootCollectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: false)
        } else if currentIndexPath.item == totalCount - 1 {
            print("➡️ Right edge reached → jump to 1")
            let target = IndexPath(item: 1, section: Section.mainBanner.rawValue)
            lootCollectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: false)
        }
    }
}
