//
//  MypageAssembly.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import Swinject

final class MypageAssembly: Assembly {
    
    func assemble(container: Container) {
        
        //MARK: - Services
        container.register(TokenManagerProtocol.self) { _ in
            TokenManager.shared
        }
        .inObjectScope(.container)
        
        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager.shared
        }
        .inObjectScope(.container)
        
        //MARK: - Repositories
        container.register(UserRepositoryProtocol.self) { resolver in
            MypageRepositoryImpl(
                tokenManager: resolver.resolve(TokenManagerProtocol.self)!,
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!
            )
        }
        
        //MARK: - UseCases
        container.register(MypageUseCaseProtocol.self) { resolver in
            MypageUseCase(
                repository: resolver.resolve(UserRepositoryProtocol.self)!
            )
        }
        
        //MARK: - ViewModels
        container.register(MypageViewModel.self) { resolver in
            MypageViewModel(
                useCase: resolver.resolve(MypageUseCaseProtocol.self)!
            )
        }
        
        container.register(MypageSettingViewModel.self) { resolver in
            MypageSettingViewModel(
            )
        }
        
        //MARK: - ViewControllers
        container.register(MypageViewController.self) { resolver in
            MypageViewController(
                viewModel: resolver.resolve(MypageViewModel.self)!
            )
        }
        
        container.register(MypageSettingViewController.self) { resolver in
            MypageSettingViewController(
                viewModel: resolver.resolve(MypageSettingViewModel.self)!
            )
        }
    }
}
