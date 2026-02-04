//
//  TagCollectionViewCell.swift
//  Talet
//
//  Created by 윤대성 on 11/11/25.
//

import UIKit

import SnapKit

final class TagCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TagCollectionViewCell"
    
    private let tagView = TagView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            print("📦 [TagCell] frame:", frame)
        }
    
    func configure(type: TagModel) {
        tagView.configure(type: type)
    }
}
