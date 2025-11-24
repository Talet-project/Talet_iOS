//
//  TaleDetailViewController.swift
//  Talet
//
//  Created by 윤대성 on 7/31/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TaleDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    
    private let navitestView = UIView()
    
    private let bookDetailBackgroundView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage.taleDetailBackground
        return view
    }()
    
    private let testBookImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.bookTest
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let bookNameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanum(.headline2)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "흥부와 놀부"
        return label
    }()
    
    private let keywordBadgesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["", ""])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemGray6
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitle("소개 🇰🇷", forSegmentAt: 0)
        segmentedControl.setTitle("소개 🇻🇳", forSegmentAt: 1)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.gray400], for: .normal)
        return segmentedControl
    }()
    
    private let aiBotCommentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.aIComent
        return view
    }()
    
    private let bookDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let bookDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bodyLong3)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "나보다 남의 처지를 먼저 헤아리는\n미덕을 담은 따스하고 정감 있는 전래동화"
        return label
    }()
    
    private let bookDescriptionBodyLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bodyLong1)
        label.textColor = .gray600
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = """
    형님 먼저! 아우 먼저!
    
    개성 있는 그림과 재미난 글로 완성도 있는 그림책을 선보여 온 「비룡소 전래동화」시리즈 스무 번째 책 『의좋은 형제』. 이 책은 섬진강 시인이라 불리는 김용택의 구수하고 정감 있는 글과 볼로냐 라가치 상 수상 작가 염혜원의 따뜻한 판화가 어우러져 잔잔한 감동을 전한다. 무슨 일이든 서로 도우며 함께하고, 좋은 것이라면 서로 양보하는 형제간의 깊은 우애를 담은 이야기다. 충청도 지역의 구수한 사투리로 이야기의 감칠맛을 더했으며 농촌의 정취와 계절감을 풍부하게 담은 그림이 이야기의 재미를 배가한다.
    """
        return label
    }()
    
    private let bottomButtonView: UIView = {
        let view = UIView()
        return view
    }()
        
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("읽기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .nanum(.label2)
        button.backgroundColor = .orange500
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 8
        button.setImage(UIImage.favorite, for: .normal)
        return button
    }()

    private let sillCutTitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let stillCutCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            contentView,
            bottomButtonView,
            navitestView
        ].forEach { view.addSubview($0) }
        
        [
            bookDetailBackgroundView,
            testBookImageView,
            bookNameLabel,
            keywordBadgesStackView,
            segmentControl,
            aiBotCommentImageView,
            bookDescriptionView,
            sillCutTitleLabel,
            stillCutCollectionView
        ].forEach { contentView.addSubview($0) }
        
        [
            bookDescriptionTitleLabel,
            bookDescriptionBodyLabel,
        ].forEach { bookDescriptionView.addSubview($0) }
        
        [
            favoriteButton,
            nextButton
        ].forEach { bottomButtonView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navitestView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        bookDetailBackgroundView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        testBookImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 140, height: 190))
            $0.top.equalTo(navitestView.snp.bottom).offset(16)
            
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        bookNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(testBookImageView.snp.bottom).offset(16)
        }
        
        keywordBadgesStackView.snp.makeConstraints {
            $0.top.equalTo(bookNameLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(keywordBadgesStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        aiBotCommentImageView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(45)
        }
        
        bookDescriptionView.snp.makeConstraints {
            $0.top.equalTo(aiBotCommentImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        bookDescriptionTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        bookDescriptionBodyLabel.snp.makeConstraints {
            $0.top.equalTo(bookDescriptionTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(62)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 56, height: 42))
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalTo(favoriteButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(42)
            $0.centerY.equalToSuperview()
        }
        
    }
}
