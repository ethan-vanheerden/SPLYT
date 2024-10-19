//
//  AccountViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

import Foundation
import Core

// MARK: - Events

enum AccountViewEvent {
    case load
    case signOut
    case deleteAccount
    case toggleDialog(type: AccountDialog, isOpen: Bool)
}

// MARK: - View Model

final class AccountViewModel: ViewModel {
    @Published private(set) var viewState: AccountViewState = .loading
    private let interactor: AccountInteractor
    private let reducer = AccountReducer()
    
    init(interactor: AccountInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: AccountViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .signOut:
            await react(domainAction: .signOut)
        case .deleteAccount:
            await react(domainAction: .submitDeleteAccount)
            await react(domainAction: .deleteAccount)
        case let .toggleDialog(type, isOpen):
            await react(domainAction: .toggleDialog(type: type, isOpen: isOpen))
        }
    }
}

// MARK: - Private

private extension AccountViewModel {
    func updateViewState(_ viewState: AccountViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: AccountDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
