//
//  LoginAssembly.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import Swinject


final class AuthAssembly: Assembly {

    func assemble(container: Container) {

        //MARK: - Core
        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager()
        }.inObjectScope(.container)

        //MARK: - Service
        container.register(AppleLoginService.self) { _ in
            AppleLoginService()
        }

        //MARK: - Repository
        container.register(AuthRepositoryProtocol.self) { resolver in
            let network = resolver.resolve(NetworkManagerProtocol.self)!
            return AuthRepositoryImpl(network: network)
        }
        
        //MARK: - UseCase
        container.register(AuthUseCaseProtocol.self) { resolver in
            let appleService = resolver.resolve(AppleLoginService.self)!
            let repository = resolver.resolve(AuthRepositoryProtocol.self)!
            return AuthUseCase(
                appleService: appleService,
                repository: repository
            )
        }
        
        //MARK: - ViewModel
        container.register(LoginViewModel.self) { resolver in
            let authUseCase = resolver.resolve(AuthUseCaseProtocol.self)!
            return LoginViewModel(loginUseCase: authUseCase)
        }
        
        container.register(SignUpViewModel.self) { (resolver, signUpToken: String) in
            let authUseCase = resolver.resolve(AuthUseCaseProtocol.self)!
            return SignUpViewModel(signUpToken: signUpToken, useCase: authUseCase)
        }
        
        //MARK: - ViewController
        container.register(LoginViewController.self) { resolver in
            let viewModel = resolver.resolve(LoginViewModel.self)!
            return LoginViewController(loginViewModel: viewModel)
        }
        
        container.register(SignUpViewController.self) { (resolver, SignUpToken: String) in
            let viewModel = resolver.resolve(SignUpViewModel.self, argument: SignUpToken)!
            return SignUpViewController(signUpToken: SignUpToken, viewModel: viewModel)
        }
    }
}
