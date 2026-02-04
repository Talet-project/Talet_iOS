//
//  TagView.swift
//  Talet
//
//  Created by 윤대성 on 11/8/25.
//

import UIKit

import SnapKit

enum TagType: String, CaseIterable {
    case courage = "용기"
    case wisdom = "지혜"
    case goodAndEvil = "선과 악"
    case sharing = "나눔"
    case familyLove = "가족애"
    case friendship = "우정"
    case justice = "정의"
    case growth = "성장"
    
    var textColor: UIColor {
        switch self {
        case .courage: return UIColor.blue400
        case .wisdom: return UIColor.green500
        case .goodAndEvil: return UIColor.orange500
        case .sharing: return UIColor.purple500
        case .familyLove: return UIColor.pink500
        case .friendship: return UIColor.green500
        case .justice: return UIColor.blue400
        case .growth: return UIColor.pink500
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .courage: return UIColor.blue50
        case .wisdom: return UIColor.green50
        case .goodAndEvil: return UIColor.orange50
        case .sharing: return UIColor.purple50
        case .familyLove: return UIColor.pink50
        case .friendship: return UIColor.green50
        case .justice: return UIColor.blue50
        case .growth: return UIColor.pink50
        }
    }
}

final class TagView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nanum(.label1)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let contentInset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    
    private func setupUI() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        [
            titleLabel,
        ].forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(contentInset)
        }
        
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // 새롭게 생성된 모델에 맞게 변경했습니다..!
    func configure(type: TagModel) {
        titleLabel.text = type.title
        titleLabel.textColor = type.foregroundColor
        backgroundColor = type.backgroundColor
    }
}
