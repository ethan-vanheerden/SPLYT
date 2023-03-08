//
//  HomeNavigationController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import SwiftUI
import Core

/// The base view controller for Workouts
final class HomeNavigationController: UINavigationController {
    init() {
        let viewModel = HomeViewModel()
        let navigationRouter = HomeNavigationRouter()
        let view = HomeView(viewModel: viewModel, navigationRouter: navigationRouter)
        
        let rootVC = UIHostingController(rootView: view)
        super.init(rootViewController: rootVC)
        self.setNavigationBarHidden(true, animated: false)
        navigationRouter.navigator = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: - SwiftUI Usable

struct HomeViewController_SwiftUI: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return HomeNavigationController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
