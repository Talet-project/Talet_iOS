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

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<HomeSectionEntity, HomeTabSection>!
    private let viewModel: HomeViewModel
    private var randomHeaderTitle: String = "오늘의 이야기"
    
    private let bannerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.homeBackground
        return imageView
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rootCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func configureCollectionView() {
        rootCollectionView.backgroundColor = .clear
        rootCollectionView.register(MainBannerCell.self, forCellWithReuseIdentifier: "MainBannerCell")
        rootCollectionView.register(RankingBookCell.self, forCellWithReuseIdentifier: "RankingBookCell")
//        rootCollectionView.register(ReadingStatusCell.self, forCellWithReuseIdentifier: "ReadingStatusCell")
        rootCollectionView.register(BookPreviewCell.self, forCellWithReuseIdentifier: "BookPreviewCell")
        rootCollectionView.register(HomeSectionHeaderView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier)
        
        view.addSubview(rootCollectionView)
        rootCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        configureCollectionView()
        configureDataSource()
        bindViewModel()
        rootCollectionView.delegate = self
        setupNavigation()
    }

// MARK: - Infinite scroll for mainBanner
    
    private func setLayout() {
        [
            backgroundImageView,
        ].forEach { view.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        
        let logoImageView = UIImageView(image: .taletTitle)
        logoImageView.contentMode = .scaleAspectFit
        
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 64, height: 35))
            $0.leading.equalToSuperview().offset(50)
        }
        
        let logoItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoItem
        
        let searchItem = UIBarButtonItem(
            image: UIImage.searchIcon,
            style: .plain,
            target: self,
            action: #selector(didTapSearch)
        )
        searchItem.tintColor = .white
        navigationItem.rightBarButtonItem = searchItem
    }
    
    @objc private func didTapSearch() {
        print("서치 버튼 눌림")
//        tabBarController?.selectedIndex = 1
    }
    
    private func bindViewModel() {
        let input = HomeViewModelImpl.Input(loadHomeContent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.randomTag
            .drive(onNext: { [weak self] tag in
                guard let self else { return }
                self.randomHeaderTitle = "\(tag.title) → \(tag.subtitle)"
            })
            .disposed(by: disposeBag)
        
        output.snapshot
            .drive(onNext: { [weak self] snapshot in
                guard let self else { return }
                
                self.dataSource.apply(snapshot, animatingDifferences: true) {
                    
                    let indexPath = IndexPath(item: 1, section: HomeSectionEntity.mainBanner.rawValue)
                    
                    if self.rootCollectionView.numberOfSections > indexPath.section,
                       self.rootCollectionView.numberOfItems(inSection: indexPath.section) > indexPath.item {
                        
                        self.rootCollectionView.scrollToItem(
                            at: indexPath,
                            at: .centeredHorizontally,
                            animated: false
                        )
                    } else {
                        print("배너 아직 준비안됨")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = HomeSectionEntity(rawValue: sectionIndex) else {
                    return HomeLayoutBuilder.defaultSection()
                }
            switch section {
            case .mainBanner:
                return HomeLayoutBuilder.mainBannerSection()
            case .popularRanking:
                return HomeLayoutBuilder.popularSection()
//            case .readingStatus:
//                return HomeLayoutBuilder.readingStatusSection()
            case .allBooksPreview:
                return HomeLayoutBuilder.themedBooksSection()
            case .randomViews:
                return HomeLayoutBuilder.themedBooksSection()
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSectionEntity, HomeTabSection>(collectionView: rootCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            guard let section = HomeSectionEntity(rawValue: indexPath.section) else {
                fatalError("Invalid section at index \(indexPath.section)")
            }
            
            switch section {
            case .mainBanner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBannerCell", for: indexPath) as! MainBannerCell
                let count = mainBannerImageData.allCases.count
                let logicalIndex = (indexPath.item - 1 + count) % count
                let image = mainBannerImageData.allCases[logicalIndex].image
                if let image {
                    print("이미지 받아옴")
                    cell.configure(image: image)
                } else {
                    print("⚠️ Missing banner image for \(mainBannerImageData.allCases[logicalIndex].rawValue)")
                    cell.configure(image: nil)
                }
                return cell
            case .popularRanking:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingBookCell", for: indexPath) as! RankingBookCell
                if case let .rankingBook(book) = itemIdentifier {
                    cell.configure(with: book.thumbnailURL)
                }
                return cell
//            case .readingStatus:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadingStatusCell", for: indexPath) as! ReadingStatusCell
//                return cell
            case .allBooksPreview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingBookCell", for: indexPath) as! RankingBookCell
                if case let .allBooksPreview(book) = itemIdentifier {
                    cell.configure(with: book.thumbnailURL)
                }
                return cell
            case .randomViews:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingBookCell", for: indexPath) as! RankingBookCell
                if case let .randomViews(book) = itemIdentifier {
                    cell.configure(with: book.thumbnailURL)
                }
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
            
            if let section = HomeSectionEntity(rawValue: indexPath.section) {
                switch section {
                case .mainBanner: return nil
                case .popularRanking: header.configure(title: "친구들이 좋아하는 인기 전래동화")
//                case .readingStatus: return nil
                case .allBooksPreview: header.configure(title: "전체 책 보기")
                case .randomViews:
                    header.configure(title: self.randomHeaderTitle)
                }
            }
            return header
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleItems = rootCollectionView.indexPathsForVisibleItems.sorted()
        guard let currentIndexPath = visibleItems.first,
              currentIndexPath.section == HomeSectionEntity.mainBanner.rawValue else { return }
        
        let totalCount = dataSource.snapshot().itemIdentifiers(inSection: .mainBanner).count
        print("✅ Scrolled to index: \(currentIndexPath.item), totalCount: \(totalCount)")
        if currentIndexPath.item == 0 {
            print("⬅️ Left edge reached → jump to \(totalCount - 2)")
            let target = IndexPath(item: totalCount - 2, section: HomeSectionEntity.mainBanner.rawValue)
            rootCollectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: false)
        } else if currentIndexPath.item == totalCount - 1 {
            print("➡️ Right edge reached → jump to 1")
            let target = IndexPath(item: 1, section: HomeSectionEntity.mainBanner.rawValue)
            rootCollectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: false)
        }
    }
}
