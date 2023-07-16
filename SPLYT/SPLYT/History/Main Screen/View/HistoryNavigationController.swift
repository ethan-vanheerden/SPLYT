//
//  HistoryNavigationController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import Core
import SwiftUI

/// The base view controller for History
final class HistoryNavigationController: UINavigationController {
    init() {
        let interactor = HistoryInteractor()
        let viewModel = HistoryViewModel(interactor: interactor)
        let navRouter = HistoryNavigationRouter()
        let view = HistoryView(viewModel: viewModel, navigationRouter: navRouter)
        
        let rootVC = UIHostingController(rootView: view)
        super.init(rootViewController: rootVC)
        self.setNavigationBarHidden(true, animated: false)
        navRouter.navigator = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: - SwiftUI Usable

struct HistoryViewController_SwiftUI: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return HistoryNavigationController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
