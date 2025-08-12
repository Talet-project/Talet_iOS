//
//  TaleDetailViewController.swift
//  Talet
//
//  Created by 윤대성 on 7/31/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TaleDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let bookDetailBackgroundView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage.taleDetailBackground
        return view
    }()
    
    private let testBookImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.bookTest
        return view
    }()
    
    private let bookNameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanum(.headline2)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "흥부와 놀부"
        return label
    }()
    
    private let keywordBadgesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            bookDetailBackgroundView,
            testBookImageView,
            bookNameLabel,
            
        ].forEach { view.addSubview($0) }
        
        bookDetailBackgroundView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        testBookImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(190)
        }
        
        bookNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(testBookImageView.snp.bottom).offset(20)
        }
    }
}
