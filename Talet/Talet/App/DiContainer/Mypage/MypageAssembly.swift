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
            UserRepositoryImpl()
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
        
        container.register(MypageEditViewModel.self) { resolver in
            MypageEditViewModel(
                useCase: resolver.resolve(UserUseCaseProtocol.self)!
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
        
        container.register(MypageEditViewController.self) { resolver in
            MypageEditViewController(
                viewModel: resolver.resolve(MypageEditViewModel.self)!
            )
        }
        
    }
}
