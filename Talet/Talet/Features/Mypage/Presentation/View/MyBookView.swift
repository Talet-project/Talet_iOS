//
//  MyBookView.swift
//  Talet
//
//  Created by 김승희 on 8/8/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class MyBookView: UIView {
    //MARK: Constants
    
    //MARK: Properties
    private var selectedIdx = 0
    private var books: [MyBookEntity] = []
    private let tabButtons: [UIButton] = []
    
    //임시 콜백
    var seeAllTap: ControlEvent<Void> {
        seeAllButton.rx.tap
    }
    
    //MARK: UI Components
    private let titleLabel = UILabel().then {
        $0.text = "나의 책장"
        $0.textColor = .black
        $0.font = .nanum(.headline1)
    }
    
    private let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let readingButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.nanum(.display1)
        
        configuration.attributedTitle = AttributedString("지금 읽고 있어요", attributes: titleContainer)
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .orange500
        
        $0.configuration = configuration
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let bookmarkButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.nanum(.display1)
        
        configuration.attributedTitle = AttributedString("찜", attributes: titleContainer)
        configuration.baseForegroundColor = .gray400
        configuration.baseBackgroundColor = .gray200
        
        $0.configuration = configuration
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private let allReadButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.nanum(.display1)
        
        configuration.attributedTitle = AttributedString("다 읽었어요", attributes: titleContainer)
        configuration.baseForegroundColor = .gray400
        configuration.baseBackgroundColor = .gray200
        
        $0.configuration = configuration
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let shadowContainer = UIView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 6
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 20
        $0.sectionInset = .zero
    }
    
    private lazy var myBookCollectionView = UICollectionView(frame: .zero,collectionViewLayout: layout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(MyBookCell.self, forCellWithReuseIdentifier: MyBookCell.id)
    }
    
    private let seeAllButton = UIButton().then {
        $0.tintColor = .gray300
        $0.setImage(.seeAllButton, for: .normal)
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func setEntity(with books: [MyBookEntity]) {
        self.books = books
        myBookCollectionView.reloadData()
    }
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        [titleLabel,
         buttonStack,
         shadowContainer
        ].forEach { addSubview($0) }
        
        shadowContainer.addSubview(backView)
        
        shadowContainer.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(-3)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(shadowContainer.snp.width).multipliedBy(0.66)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [readingButton,
         bookmarkButton,
         allReadButton
        ].forEach { buttonStack.addArrangedSubview($0) }
        
        [myBookCollectionView,
         seeAllButton
        ].forEach { backView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(40)
            $0.width.equalTo(backView.snp.width).multipliedBy(0.75)
        }
        
        myBookCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(myBookCollectionView.snp.width).multipliedBy(0.9)
        }
        
        seeAllButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalToSuperview().multipliedBy(0.17)
            $0.height.equalTo(seeAllButton.snp.width)
        }
    }
}


extension MyBookView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 190)
    }
}

extension MyBookView: UICollectionViewDelegate {
    
}

extension MyBookView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBookCell.id, for: indexPath) as? MyBookCell else {
            return UICollectionViewCell()
        }
        cell.configure(cellModel: books[indexPath.item])
        return cell
    }
}
