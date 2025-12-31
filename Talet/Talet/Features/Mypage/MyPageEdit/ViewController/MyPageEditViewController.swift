//
//  MyPageEditViewController.swift
//  Talet
//
//  Created by 김승희 on 12/31/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


class MyPageEditViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    
    //MARK: UI Components
    private lazy var profileButton = UIButton().then {
        $0.setImage(.placeholder, for: .normal)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.orange400.cgColor
    }
    
    
    
    //MARK: init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setLayout()
    }
    
    //MARK: Methods
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
    }
    
    //MARK: Extensions
}
