//
//  LoginViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import Core

// MARK: - Events

enum LoginViewEvent: Equatable {
    case load
    case toggleCreateAccount(isCreateAccount: Bool)
    case updateField(field: LoginField)
    case submit
    case fieldChangedFocus(field: LoginField, isFocused: Bool)
}

// MARK: - View Model

final class LoginViewModel: ViewModel {
    @Published private(set) var viewState: LoginViewState = .loading
    private let interactor: LoginInteractor
    private let reducer = LoginReducer()
    
    init(interactor: LoginInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: LoginViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        case .toggleCreateAccount(let isCreateAccount):
            await react(domainAction: .toggleCreateAccount(isCreateAccount: isCreateAccount))
        case .updateField(let field):
            await react(domainAction: .updateField(field: field))
        case .submit:
            await react(domainAction: .submit)
        case let .fieldChangedFocus(field, isFocused):
            await react(domainAction: .fieldChangedFocus(field: field, isFocused: isFocused))
        }
    }
}

// MARK: - Private

private extension LoginViewModel {
    func updateViewState(_ viewState: LoginViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: LoginDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
