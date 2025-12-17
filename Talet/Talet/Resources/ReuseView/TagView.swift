//
//  TagView.swift
//  Talet
//
//  Created by 윤대성 on 11/8/25.
//

import UIKit

import SnapKit

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
    
    func configure(type: TagType) {
        titleLabel.text = type.rawValue
        titleLabel.textColor = type.textColor
        backgroundColor = type.backgroundColor
    }
}
