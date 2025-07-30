//
//  GenderPickerView.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import SnapKit
import Then


class GenderPickerView: UIView {
    //MARK: Constants
    
    //MARK: Properties
    private var isSelected = false
    private var imageAspectRatio: CGFloat = 0.7
    
    //MARK: UI Components
    private let backgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let nameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .nanum(.display1)
        $0.textColor = .gray400
    }
    
    private let checkImageView = UIImageView().then {
        $0.image = .checkIcon
        $0.isHidden = true
    }
    
    //MARK: init
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func configure(image: UIImage, name: String) {
        imageView.image = image
        nameLabel.text = name
        
        let size = image.size
        imageAspectRatio = size.height / size.width
        
        setLayout()
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        backgroundView.backgroundColor = selected ? .orange500 : .gray50
        nameLabel.textColor = selected ? .white : .gray400
        checkImageView.isHidden = !selected
    }
    
    //MARK: Bindings
    
    //MARK: Layout
    private func setLayout() {
        self.addSubview(backgroundView)
        
        [imageView,
         nameLabel,
         checkImageView].forEach { backgroundView.addSubview($0) }
        
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(imageView.snp.width).multipliedBy(imageAspectRatio)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.right.equalToSuperview().inset(10)
            $0.width.height.equalTo(20)
        }
    }
}
