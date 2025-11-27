//
//  ExploreViewController.swift
//  Talet
//
//  Created by 윤대성 on 8/27/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

struct ExploreModel {
    let id: String
    let name: String
    let description: String
    let thumbnail: String
    let tags: [String]
//    let shorts: object
//    let bookmark: Bool
}

class ExploreViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ExploreViewModel
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰 상태 관리
    private var didAdjustInitialOffset = false
    
    private let taleCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = -16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TaleCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupCollectionView()
        bind()
        setNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !didAdjustInitialOffset else { return }
        didAdjustInitialOffset = true
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        
        if let offsetX = targetOffsetXToCenterCell(at: firstIndexPath) {
            taleCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            applyCenterScaling()
        }
    }
    
    private func setupCollectionView() {
        taleCollectionView.register(
            TaleCollectionViewCell.self,
            forCellWithReuseIdentifier: TaleCollectionViewCell.reuseIdentifier
        )
        
        taleCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        taleCollectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.applyCenterScaling()
            })
            .disposed(by: disposeBag)
        
        taleCollectionView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let center = CGPoint(
                    x: self.taleCollectionView.bounds.midX + self.taleCollectionView.contentOffset.x,
                    y: self.taleCollectionView.bounds.midY + self.taleCollectionView.contentOffset.y
                )
                if let indexPath = self.taleCollectionView.indexPathForItem(at: center) {
                    print("현재 노출된 index:", indexPath.item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        let leftLabel: UILabel = {
            let label = UILabel()
            label.text = "둘러보기"
            label.font = .nanum(.headline1)
            label.textColor = .white
            return label
        }()
        
        let leftItem = UIBarButtonItem(customView: leftLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    private func bind() {
        let input = ExploreViewModelImpl.Input()
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(taleCollectionView.rx.items(
                cellIdentifier: TaleCollectionViewCell.reuseIdentifier,
                cellType: TaleCollectionViewCell.self
            )) { index, item, cell in
                cell.configure(with: item, index: index)
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = .orange300
        
        [
            taleCollectionView,
        ].forEach { view.addSubview($0) }
           
        taleCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(29)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
        }
    }
    
    private func applyCenterScaling() {
        let centerX = taleCollectionView.contentOffset.x + taleCollectionView.bounds.width / 2
        let maxDistance: CGFloat = 300
        let minScale: CGFloat = 0.86
        
        for cell in taleCollectionView.visibleCells {
            let cellCenterX = taleCollectionView.convert(cell.center, to: taleCollectionView).x
            let distance = abs(cellCenterX - centerX)
            let ratio = max(0, 1 - distance / maxDistance)
            let scale = minScale + (1 - minScale) * ratio
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            cell.layer.zPosition = CGFloat(Float(scale))
        }
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.9
        let height = collectionView.bounds.height * 1
        return CGSize(width: width, height: height)
    }
}

extension ExploreViewController {
    /// 현재 상태(레이아웃, contentSize 등)를 기준으로
    /// "이 indexPath 셀을 화면 정중앙에 두려면 어느 offset.x가 되어야 하는가?" 를 계산
    /// 계산 성공 시 clamped된 offsetX를 리턴, 실패 시 nil
    private func targetOffsetXToCenterCell(at indexPath: IndexPath) -> CGFloat? {
        guard let layout = taleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return nil }
        taleCollectionView.layoutIfNeeded()
        
        guard let attr = layout.layoutAttributesForItem(at: indexPath) else { return nil }
        
        let idealOffsetX = attr.center.x - taleCollectionView.bounds.width / 2
        
        let leftInset = taleCollectionView.contentInset.left
        let rightInset = taleCollectionView.contentInset.right
        let maxOffsetX = taleCollectionView.contentSize.width - taleCollectionView.bounds.width + rightInset
        let minOffsetX = -leftInset
        
        let clamped = max(min(idealOffsetX, maxOffsetX), minOffsetX)
        return clamped
    }
}

extension ExploreViewController {
    private func nearestIndexPathToCenter(proposedOffsetX: CGFloat) -> IndexPath? {
        guard let layout = taleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return nil }
        
        let proposedRect = CGRect(
            x: proposedOffsetX,
            y: 0,
            width: taleCollectionView.bounds.width,
            height: taleCollectionView.bounds.height
        )
        
        guard let attributesList = layout.layoutAttributesForElements(in: proposedRect),
              !attributesList.isEmpty
        else { return nil }
        
        let collectionCenterX = proposedOffsetX + taleCollectionView.bounds.width / 2
        
        var closestAttr: UICollectionViewLayoutAttributes?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for attr in attributesList {
            let distance = abs(attr.center.x - collectionCenterX)
            if distance < minDistance {
                minDistance = distance
                closestAttr = attr
            }
        }
        
        guard let targetAttr = closestAttr else { return nil }
        return targetAttr.indexPath
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let proposedOffsetX = targetContentOffset.pointee.x
        
        guard let indexPath = nearestIndexPathToCenter(proposedOffsetX: proposedOffsetX) else { return }
        guard let finalOffsetX = targetOffsetXToCenterCell(at: indexPath) else { return }
        
        targetContentOffset.pointee.x = finalOffsetX
    }
}
