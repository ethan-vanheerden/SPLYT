////
////  LoginNavigationRouter.swift
////  SPLYT
////
////  Created by Ethan Van Heerden on 8/19/23.
////
//
//import Foundation
//import Core
//
//// MARK: - Navigation Events
//
//enum LoginNavigationEvent {
//    case goToHome
//}
//
//// MARK: - Router
//
//final class LoginNavigationRouter: NavigationRouter {
//    weak var navigator: Navigator?
//    private let mainViewModel: MainViewModel
//    
//    init(mainViewModel: MainViewModel) {
//        self.mainViewModel = mainViewModel
//    }
//    
//    
//    
//    func navigate(_ event: LoginNavigationEvent) {
//        switch event {
//        case .goToHome:
//            handleGoToHome()
//        }
//    }
//}
//
//// MARK: - Private
//
//private extension LoginNavigationRouter {
//    func handleGoToHome() {
//        mainViewModel.send(.load, taskPriority: .userInitiated)
//        navigator?.dismiss(animated: false)
//    }
//}
