//
//  MypageAssembly.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import Swinject

final class MypageAssembly: Assembly {
    
    func assemble(container: Container) {
        
        //MARK: - Repositories
        container.register(UserRepositoryProtocol.self) { resolver in
            UserRepositoryImpl(
                tokenManager: resolver.resolve(TokenManagerProtocol.self)!,
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!
            )
        }
        
        //MARK: - UseCases
        container.register(UserUseCaseProtocol.self) { resolver in
            UserUseCase(
                repository: resolver.resolve(UserRepositoryProtocol.self)!
            )
        }
        
        //MARK: - ViewModels
        container.register(MypageViewModel.self) { resolver in
            MypageViewModel(
                useCase: resolver.resolve(UserUseCaseProtocol.self)!
            )
        }
        
        container.register(MypageSettingViewModel.self) { resolver in
            MypageSettingViewModel(
                useCase: resolver.resolve(AuthUseCaseProtocol.self)!
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
