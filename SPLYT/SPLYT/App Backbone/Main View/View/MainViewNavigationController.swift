//
//  MainViewHostingController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import SwiftUI

/// The base navigation controller for the app
final class MainViewNavigationController: UINavigationController {
    init() {
        let interactor = MainViewInteractor()
        let viewModel = MainViewModel(interactor: interactor)
        let navRouter = MainViewNavigationRouter(viewModel: viewModel)
        let authManager = AuthManager()
        
        let loginInteractor = LoginInteractor()
        let loginViewModel = LoginViewModel(interactor: loginInteractor)
        
        let view = MainView(viewModel: viewModel,
                            authManager: authManager,
                            loginViewModel: loginViewModel,
                            navigationRouter: navRouter)
        
        let rootVC = UIHostingController(rootView: view)
        super.init(rootViewController: rootVC)
        self.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = self
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: - SwiftUI Usable

struct MainViewController_SwiftUI: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return MainViewNavigationController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
