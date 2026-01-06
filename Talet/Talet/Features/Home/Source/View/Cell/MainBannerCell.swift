//
//  MainBannerCell.swift
//  Talet
//
//  Created by 윤대성 on 7/25/25.
//

import UIKit

import SnapKit

final class MainBannerCell: UICollectionViewCell {
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(bannerImageView)
        
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(image: UIImage?) {
        bannerImageView.image = image
        // Debug hint: uncomment to visualize the image view frame
        // contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.1)
    }
    
//    func configure(with color: UIColor) {
//        backgroundColor = color
//    }
}
