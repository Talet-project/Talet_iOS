//
//  RankingBookCell.swift
//  Talet
//
//  Created by 윤대성 on 7/25/25.
//

import UIKit

import Kingfisher
import SnapKit

final class RankingBookCell: UICollectionViewCell {
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    private func setupUI() {
        [
            thumbnailImageView
        ].forEach { contentView.addSubview($0) }
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with thumbnailURL: URL?) {
        let placeholder = UIImage.bookTest
        
        guard let thumbnailURL else {
            thumbnailImageView.image = placeholder
            return
        }
        
        thumbnailImageView.kf.setImage(
            with: thumbnailURL,
            placeholder: placeholder
        )
    }
}
