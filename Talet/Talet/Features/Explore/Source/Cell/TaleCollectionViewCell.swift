//
//  TaleCollectionViewCell.swift
//  Talet
//
//  Created by 윤대성 on 8/29/25.
//

import UIKit

import SnapKit

// 백그라운드 이미지
enum TaleCardBackground: String, CaseIterable {
    case green = "cardBackgroundGreen"
    case purple = "cardBackgroundPurple"
    case skyBlue = "cardBackgroundSkyBlue"
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

final class TaleCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TaleCollectionViewCell"
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let languageSeleteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let fairyTaleImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.bookTest
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let fairyTaleTitle: UILabel = {
        let label = UILabel()
        label.font = .nanum(.headline2)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let fairyTaleDescription: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bodyLong2)
        label.textColor = .gray500
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(.favorite, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 8
        
        button.imageView?.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.center.equalToSuperview()
        }
        
        return button
    }()
    
    private let readButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanum(.body1)
        button.setTitle("읽기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange500
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCollectionViewCell.self,
                                forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private var tags: [TagModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("📐 [TagCV] frame:", tagCollectionView.frame)
        tagCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        [
            backgroundImage,
            fairyTaleImage,
            fairyTaleTitle,
            fairyTaleDescription,
            favoriteButton,
            readButton,
            tagCollectionView
        ].forEach { contentView.addSubview($0) }
        
        fairyTaleImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(62)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 190, height: 298))
        }
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fairyTaleTitle.snp.makeConstraints {
            $0.top.equalTo(fairyTaleImage.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
        }
        
        fairyTaleDescription.snp.makeConstraints {
            $0.top.equalTo(fairyTaleTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-18)
            $0.leading.equalToSuperview().offset(18)
            $0.size.equalTo(CGSize(width: 56, height: 42))
        }
        
        readButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-18)
            $0.leading.equalTo(favoriteButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-18)
            $0.height.equalTo(42)
        }
        
        tagCollectionView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(-83)
//            $0.height.equalTo(30)
            $0.top.equalTo(fairyTaleDescription.snp.bottom).offset(12)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.height.equalTo(30)
        }
    }
    
    func configure(with model: ExploreModel, index: Int) {
        fairyTaleTitle.text = model.name
        fairyTaleDescription.text = model.description
        
        // 임시 처리, 이후 Explore관련 model, viewmodel 수정
        tags = model.tags
            .compactMap { BookTag.from(title: $0) }
            .map { BookTagStyleProvider.style(for: $0) }
//        print("🎯 tags:", model.tags, "→ 필터 후:", tags)
        DispatchQueue.main.async { [weak self] in
                self?.tagCollectionView.reloadData()
            }
        
        let backgrounds = TaleCardBackground.allCases
        let background = backgrounds[index % backgrounds.count]
        backgroundImage.image = background.image
    }
}

extension TaleCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(type: tags[indexPath.item])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let font = UIFont.nanum(.label1)
        let horizontalPadding: CGFloat = 20
        let spacing: CGFloat = 8

        let totalCellWidth = tags.reduce(CGFloat(0)) { sum, tag in
            let textWidth = (tag.title as NSString).size(withAttributes: [.font: font]).width
            return sum + ceil(textWidth) + horizontalPadding
        }
        let totalSpacingWidth = spacing * CGFloat(max(tags.count - 1, 0))
        let totalWidth = totalCellWidth + totalSpacingWidth
        let inset = max((collectionView.bounds.width - totalWidth) / 2, 0)
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}




// 임시
extension BookTag {
    static func from(title: String) -> BookTag? {
        switch title {
        case "용기": return .courage
        case "지혜": return .wisdom
        case "선과 악": return .goodAndEvil
        case "나눔": return .sharing
        case "가족애": return .familyLove
        case "우정": return .friendship
        case "정의": return .justice
        case "성장": return .growth
        default: return nil
        }
    }
}
