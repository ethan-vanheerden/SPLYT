//
//  MainViewNavigationRouter.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/21/23.
//

import Foundation
import Core
import SwiftUI

// MARK: - Navigation Events

enum MainViewNavigationEvent {
    case goToLogin
}

// MARK: - Router

final class MainViewNavigationRouter: NavigationRouter {
    weak var navigator: Navigator?
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    func navigate(_ event: MainViewNavigationEvent) {
        switch event {
        case .goToLogin:
            handleGoToLogin()
        }
    }
}

// MARK: - Private

private extension MainViewNavigationRouter {
    func handleGoToLogin() {
        let interactor = LoginInteractor()
        let viewModel = LoginViewModel(interactor: interactor)
//        let navRouter = LoginNavigationRouter(mainViewModel: self.viewModel)
//        navRouter.navigator = navigator
        let view = LoginView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        
        navigator?.present(vc, animated: false)
    }
}
