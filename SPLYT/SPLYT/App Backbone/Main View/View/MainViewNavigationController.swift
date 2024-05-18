//
//  MainViewHostingController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import SwiftUI
import DesignSystem

/// The base navigation controller for the app
final class MainViewNavigationController<A: AuthManagerType>: UINavigationController {
    init(authManager: A = AuthManager()) {
        let interactor = MainViewInteractor()
        let viewModel = MainViewModel(interactor: interactor)
        
        let loginInteractor = LoginInteractor()
        let loginViewModel = LoginViewModel(interactor: loginInteractor)
        
        let view = MainView(viewModel: viewModel,
                            authManager: authManager,
                            loginViewModel: loginViewModel)
            .environmentObject(UserTheme.shared)
        
        let rootVC = UIHostingController(rootView: view)
        super.init(rootViewController: rootVC)
        self.setNavigationBarHidden(true, animated: false)
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
