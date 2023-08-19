//
//  MainViewHostingController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import SwiftUI

final class MainViewHostingController: UIHostingController<MainView<MainViewModel>> {

    init(viewModel: MainViewModel) {
        let view = MainView(viewModel: viewModel)
        super.init(rootView: view)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: - SwiftUI Usable

struct MainViewHostingController_SwiftUI: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let interactor = MainViewInteractor()
        let viewModel = MainViewModel(interactor: interactor)
        return MainViewHostingController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
