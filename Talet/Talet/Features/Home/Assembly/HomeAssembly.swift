//
//  HomeAssembly.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import Swinject

final class HomeAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager.shared
        }.inObjectScope(.container)
        
//        container.register(BookResponseRepository.self) { resolver in
//            BookResponseRepositoryImpl(network: resolver.resolve(NetworkManager.self)!)
//        }
        
        container.register(BookResponseRepository.self) { resolver in
            let network = resolver.resolve(NetworkManagerProtocol.self)!
            return BookResponseRepositoryImpl(network: network)
        }
        
        container.register(PopularRankingBookUseCase.self) { resolver in
            PopularRankingBookUseCaseImpl(repository: resolver.resolve(BookResponseRepository.self)!)
        }
        
        container.register(HomeViewModel.self) { resolver in
            HomeViewModelImpl(PopularRankingBookUseCase: resolver.resolve(PopularRankingBookUseCase.self)!)
        }
        
        container.register(HomeViewController.self) { resolver in
            let viewModel = resolver.resolve(HomeViewModel.self)!
            return HomeViewController(viewModel: viewModel)
        }
    }
}
