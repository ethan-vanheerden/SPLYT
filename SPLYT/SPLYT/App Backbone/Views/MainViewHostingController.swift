//
//  MainViewHostingController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/17/22.
//

import Foundation
import SwiftUI

final class MainViewHostingController<VM: MainViewModelType>: UIHostingController<MainView<VM>> {

    init(viewModel: VM) {
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
        return MainViewHostingController(viewModel: MainViewModel())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
