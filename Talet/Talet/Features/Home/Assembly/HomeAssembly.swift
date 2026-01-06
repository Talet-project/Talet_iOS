//
//  HomeAssembly.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import Swinject

final class HomeAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(HomeViewModel.self) { resolver in
            HomeViewModelImpl()
        }
        
        container.register(HomeViewController.self) { resolver in
            let viewModel = resolver.resolve(HomeViewModel.self)!
            return HomeViewController(viewModel: viewModel)
        }
    }
}
