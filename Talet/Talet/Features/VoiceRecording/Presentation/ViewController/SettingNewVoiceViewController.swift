//
//  SettingNewVoiceViewController.swift
//  TaletView
//
//  Created by 김승희 on 11/12/25.
//

import UIKit

import SnapKit
import Then


final class SettingNewVoiceViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    
    //MARK: UI Components
    
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
        view.backgroundColor = .orange
    }
    
    //MARK: Extensions
}
