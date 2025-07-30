//
//  HomeSectionHeaderView.swift
//  Talet
//
//  Created by 윤대성 on 7/27/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class HomeSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier: String = "HomeSectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
