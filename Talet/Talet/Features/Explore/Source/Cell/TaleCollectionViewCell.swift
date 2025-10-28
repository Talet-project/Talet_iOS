//
//  TaleCollectionViewCell.swift
//  Talet
//
//  Created by 윤대성 on 8/29/25.
//

import UIKit

import SnapKit

final class TaleCollectionViewCell: UICollectionViewCell {
    
    private let fairyTaleImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.bookTest
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        
        [
            fairyTaleImage
        ].forEach { addSubview($0) }
        
        fairyTaleImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(62)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 190, height: 298))
        }
    }
    
    
    
}
