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

class ExploreViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let itemsRelay = BehaviorRelay<[Int]>(value: Array(0..<10)) //더미
    
    // 뷰 상태 관리
    private var didAdjustInitialOffset = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "둘러보기"
        label.font = .nanum(.headline1)
        label.textColor = .white
        return label
    }()
    
    private let taleCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
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
        bind()
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
    
    private func bind() {
        taleCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        itemsRelay
            .bind(to: taleCollectionView.rx.items(cellIdentifier: "Cell", cellType: TaleCollectionViewCell.self)) { row, item, cell in
                // TODO: Configure cell with your model
            }
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
                let center = CGPoint(x: self.taleCollectionView.bounds.midX + self.taleCollectionView.contentOffset.x,
                                     y: self.taleCollectionView.bounds.midY + self.taleCollectionView.contentOffset.y)
                if let indexPath = self.taleCollectionView.indexPathForItem(at: center) {
                    print("현재 노출된 index:", indexPath.item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = .orange300
        
        [
            titleLabel,
            taleCollectionView
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
//        taleCollectionView.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
//        }
        
        taleCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
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
        let width = collectionView.bounds.width * 0.8
        let height = collectionView.bounds.height * 0.9
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
        
        // 그 셀의 attributes (frame/center 등)
        guard let attr = layout.layoutAttributesForItem(at: indexPath) else { return nil }
        
        // "이 셀의 center.x를 화면 중앙에 맞추려면" 필요한 이상적인 offset
        let idealOffsetX = attr.center.x - taleCollectionView.bounds.width / 2
        
        // contentInset 고려해서 clamp
        let leftInset = taleCollectionView.contentInset.left
        let rightInset = taleCollectionView.contentInset.right
        let maxOffsetX = taleCollectionView.contentSize.width - taleCollectionView.bounds.width + rightInset
        let minOffsetX = -leftInset
        
        let clamped = max(min(idealOffsetX, maxOffsetX), minOffsetX)
        return clamped
    }
}

extension ExploreViewController {
    
    /// 스크롤이 멈추려는 시점의 proposedOffsetX 기준으로,
    /// "가운데에 가장 가까운 셀"의 indexPath를 찾아서 리턴
    private func nearestIndexPathToCenter(proposedOffsetX: CGFloat) -> IndexPath? {
        guard let layout = taleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return nil }
        
        // 스크롤이 멈출 거라고 iOS가 예측한 영역
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
        
        // 1) 가운데에 가장 가까운 셀 찾기
        guard let indexPath = nearestIndexPathToCenter(proposedOffsetX: proposedOffsetX) else { return }
        
        // 2) 그 셀을 실제로 중앙에 맞추는 offset 계산 (재사용!)
        guard let finalOffsetX = targetOffsetXToCenterCell(at: indexPath) else { return }
        
        targetContentOffset.pointee.x = finalOffsetX
    }
}

//extension ExploreViewController {
//    func scrollViewWillEndDragging(
//        _ scrollView: UIScrollView,
//        withVelocity velocity: CGPoint,
//        targetContentOffset: UnsafeMutablePointer<CGPoint>
//    ) {
//        guard let layout = taleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//        // Proposed offset from the system
//        let proposedOffsetX = targetContentOffset.pointee.x
//        let proposedRect = CGRect(x: proposedOffsetX,
//                                  y: 0,
//                                  width: taleCollectionView.bounds.width,
//                                  height: taleCollectionView.bounds.height)
//
//        // Find the attributes nearest to the horizontal center of the collection view
//        guard let attributes = layout.layoutAttributesForElements(in: proposedRect), !attributes.isEmpty else { return }
//
//        let collectionCenterX = proposedOffsetX + taleCollectionView.bounds.width / 2
//
//        var closest: UICollectionViewLayoutAttributes?
//        var minDistance = CGFloat.greatestFiniteMagnitude
//
//        for attr in attributes {
//            let distance = abs(attr.center.x - collectionCenterX)
//            if distance < minDistance {
//                minDistance = distance
//                closest = attr
//            }
//        }
//
//        guard let targetAttr = closest else { return }
//
//        // Adjust the target offset so that the selected cell centers in the view
//        let newOffsetX = targetAttr.center.x - taleCollectionView.bounds.width / 2
//        let leftInset = taleCollectionView.contentInset.left
//        let rightInset = taleCollectionView.contentInset.right
//        let maxOffsetX = taleCollectionView.contentSize.width - taleCollectionView.bounds.width + rightInset
//        let minOffsetX = -leftInset
//
//        targetContentOffset.pointee.x = max(min(newOffsetX, maxOffsetX), minOffsetX)
//    }
//}
