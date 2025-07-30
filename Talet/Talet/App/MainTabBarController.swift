//
//  MainTabBarController.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    let homeVM = HomeViewModelImpl()
    let homeVC = HomeViewController(viewModel: homeVM)
    
//    let exploreTabVM = ExploreTabViewModel()
//    let exploreTabVC = ExploreTabViewController(viewModel: exploreTabVM)
    
    let myPageVM = MyPageViewModel()
    let myPageVC = MyPageViewController(viewModel: myPageVM)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "home"), tag: 0)
        
        myPageVC.tabBarItem = UITabBarItem(title: "둘러보기", image: UIImage(systemName: "explore"), tag: 1)
        
        myPageVC.tabBarItem = UITabBarItem(title: "마이", image: UIImage(systemName: "profile"), tag: 2)
        
        self.viewControllers = [homeVC, homeVC, /*exploreTabVC,*/ myPageVC]
    }
}
