//
//  MypageSettingAssembly.swift
//  Talet
//
//  Created by 김승희 on 12/30/25.
//

import Swinject


final class MypageSettingAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // TODO: AuthUseCase가 생기면 주석 해제
        // container.register(AuthUseCaseProtocol.self) { resolver in
        //     AuthUseCase(
        //         repository: resolver.resolve(AuthRepositoryProtocol.self)!
        //     )
        // }
        
        container.register(MypageSettingViewModel.self) { resolver in
            MypageSettingViewModel()
            // TODO: AuthUseCase 추가되면
            // MypageSettingViewModel(
            //     authUseCase: resolver.resolve(AuthUseCaseProtocol.self)!
            // )
        }
        
        container.register(MypageSettingViewController.self) { resolver in
            MypageSettingViewController(
                viewModel: resolver.resolve(MypageSettingViewModel.self)!
            )
        }
    }
}
