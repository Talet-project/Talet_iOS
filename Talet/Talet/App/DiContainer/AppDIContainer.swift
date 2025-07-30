//
//  AppDIContainer.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import Swinject

final class AppDIContainer {
    static let shared = AppDIContainer()
    let assembler: Assembler
    let container: Container
    
    private init() {
        container = Container()
        
        assembler = Assembler([
            HomeDataSourceAssembly(),
            HomeRepositoryAssembly(),
            HomeUseCaseAssembly(),
            HomeAssembly(),
        ], container: container)
    }
    
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = assembler.resolver.resolve(type) else {
            fatalError("resolve 단계에서 실패했어요!")
        }
        return resolved
    }
}

extension AppDIContainer {
    func makeMainTabBarController() -> MainTabBarController {
        let homeVC = resolve(HomeViewController.self)
        let myPageVC = MypageViewController()
        
//        let exploreVC = resolve(ExploreTabViewController.self)
//        let myPageVC = resolve(MyPageViewController.self)

        return MainTabBarController(
            homeVC: homeVC,
//            exploreVC: homeVC,
//            exploreVC: exploreVC,
            myPageVC: myPageVC
        )
    }
}
