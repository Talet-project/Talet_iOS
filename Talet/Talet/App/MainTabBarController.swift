//
//  MainTabBarController.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let homeVC: HomeViewController
//    private let exploreVC: exploreViewController
    private let myPageVC: MypageViewController
    
    init(homeVC: HomeViewController, myPageVC: MypageViewController) {
        self.homeVC = homeVC
        self.myPageVC = myPageVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "homeNotClick")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "homeClick")?.withRenderingMode(.alwaysOriginal)
        )

//        exploreVC.tabBarItem = UITabBarItem(
//            title: "둘러보기",
//            image: UIImage(named: "exploreNotClick"),
//            selectedImage: UIImage(named: "exploreClick")
//        )

        myPageVC.tabBarItem = UITabBarItem(
            title: "마이",
            image: UIImage(named: "profileNotClick")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "profileClick")?.withRenderingMode(.alwaysOriginal)
        )

        self.viewControllers = [homeVC, /*exploreVC,*/ myPageVC]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // 선택되지 않은 상태
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        
        // 선택된 상태
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
