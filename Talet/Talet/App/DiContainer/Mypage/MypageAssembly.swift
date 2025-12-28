//
//  MypageAssembly.swift
//  Talet
//
//  Created by 윤대성 on 7/30/25.
//

import Swinject

final class MypageAssembly: Assembly {
    
    func assemble(container: Container) {

        container.register(TokenManagerProtocol.self) { _ in
            TokenManager.shared
        }
        .inObjectScope(.container)
        
        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager.shared
        }
        .inObjectScope(.container)
        
        container.register(MypageRepositoryProtocol.self) { resolver in
            MypageRepositoryImpl(
                tokenManager: resolver.resolve(TokenManagerProtocol.self)!,
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!
            )
        }
        
        container.register(MypageUseCaseProtocol.self) { resolver in
            MypageUseCase(
                repository: resolver.resolve(MypageRepositoryProtocol.self)!
            )
        }
        
        container.register(MypageViewModel.self) { resolver in
            MypageViewModel(
                useCase: resolver.resolve(MypageUseCaseProtocol.self)!
            )
        }
        
        container.register(MypageViewController.self) { resolver in
            MypageViewController(
                viewModel: resolver.resolve(MypageViewModel.self)!
            )
        }
    }
}
