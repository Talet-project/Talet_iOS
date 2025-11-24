//
//  ExploreAssembly.swift
//  Talet
//
//  Created by 윤대성 on 11/6/25.
//

import Swinject

final class ExploreAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ExploreViewModel.self) { resolver in
            ExploreViewModelImpl()
        }
        
        container.register(ExploreViewController.self) { resolver in
            let viewModel = resolver.resolve(ExploreViewModel.self)!
            return ExploreViewController(viewModel: viewModel)
        }
    }
}
