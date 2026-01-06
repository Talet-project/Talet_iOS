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
            AuthAssembly(),
            HomeDataSourceAssembly(),
            HomeRepositoryAssembly(),
            HomeUseCaseAssembly(),
            HomeAssembly(),
            ExploreAssembly(),
            MypageAssembly()
            
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
    func makeLoginViewController() -> LoginViewController {
        return container.resolve(LoginViewController.self)!
    }
    
    func makeSignUpViewController(signUpToken: String) -> SignUpViewController {
        return container.resolve(SignUpViewController.self, argument: signUpToken)!
    }
    
    func makeMypageSettingViewController() -> MypageSettingViewController {
        return container.resolve(MypageSettingViewController.self)!
    }
    
    func makeMypageEditViewController() -> MypageEditViewController {
        return container.resolve(MypageEditViewController.self)!
    }
    
    func makeMainTabBarController() -> MainTabBarController {
        let homeVC = resolve(HomeViewController.self)
        let exploreVC = resolve(ExploreViewController.self)
        let myPageVC = resolve(MypageViewController.self)
        
//        let exploreVC = resolve(ExploreTabViewController.self)

        return MainTabBarController(
            homeVC: homeVC,
//            exploreVC: homeVC,
            exploreVC: exploreVC,
            myPageVC: myPageVC
        )
    }
}
