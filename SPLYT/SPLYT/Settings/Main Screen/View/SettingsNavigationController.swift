//
//  SettingsViewController.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/22.
//

import SwiftUI
import Core

/// The base view controller for Settings
final class SettingsNavigationController: UINavigationController {
    init() {
        let interactor = SettingsInteractor()
        let viewModel = SettingsViewModel(interactor: interactor)
        let view = SettingsView(viewModel: viewModel)
        let rootVC = UIHostingController(rootView: view)
        super.init(rootViewController: rootVC)
        self.setNavigationBarHidden(true, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

// MARK: SwiftUI Usable

struct SettingsViewController_SwiftUI: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return SettingsNavigationController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
