//
//  MypageSettingCell.swift
//  Talet
//
//  Created by 김승희 on 12/30/25.
//

import UIKit

import SnapKit
import Then


class MypageSettingCell: UITableViewCell {
    static let id = "MypageSettingCell"
    
    //MARK: UI Components
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.body2)
        $0.textColor = .black
    }
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    //MARK: Layout
    private func setLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
