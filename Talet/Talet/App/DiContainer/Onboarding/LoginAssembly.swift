//
//  LoginAssembly.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import Swinject


final class LoginAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(TokenManagerProtocol.self) { _ in
            TokenManager.shared
        }.inObjectScope(.container)
        
        container.register(AppleLoginService.self) { _ in
            AppleLoginService()
        }
        
        container.register(LoginRepositoryProtocol.self) { _ in
            return LoginRepositoryImpl(network: NetworkManager.shared)
        }
        
        container.register(AuthUseCaseProtocol.self) { resolver in
            let appleService = resolver.resolve(AppleLoginService.self)!
            let repository = resolver.resolve(LoginRepositoryProtocol.self)!
            let tokenManager = resolver.resolve(TokenManagerProtocol.self)!
            return AuthUseCase(
                appleService: appleService,
                repository: repository,
                tokenManager: tokenManager
            )
        }
        
        container.register(LoginViewModel.self) { resolver in
            let authUseCase = resolver.resolve(AuthUseCaseProtocol.self)!
            return LoginViewModel(loginUseCase: authUseCase)
        }
        
        container.register(LoginViewController.self) { resolver in
            let viewModel = resolver.resolve(LoginViewModel.self)!
            return LoginViewController(loginViewModel: viewModel)
        }
    }
}
