//
//  ExploreViewController.swift
//  Talet
//
//  Created by 윤대성 on 8/27/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ExploreViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .orange300
    }
}
