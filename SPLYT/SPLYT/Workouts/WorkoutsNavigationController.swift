//
//  WorkoutsNavigationController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/20/22.
//

import SwiftUI
import Core

/// The base view controller for Workouts
final class WorkoutsNavigationController: UINavigationController {
    init() {
        let viewModel = WorkoutsViewModel()
        let navigationRouter = WorkoutsNavigationRouter()
        let view = WorkoutsView(viewModel: viewModel, navigationRouter: navigationRouter)
        
        let rootVC = UIHostingController(rootView: view)
        super.init(rootViewController: rootVC)
        navigationRouter.navigator = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: - SwiftUI Usable

struct WorkoutsViewController_SwiftUI: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return WorkoutsNavigationController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
