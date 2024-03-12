//
//  LicensesViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation
import Core

// MARK: - Events

enum LicenseViewEvent {
    case load
}

// MARK: - View Model

final class LicenseViewModel: ViewModel {
    @Published private(set) var viewState: LicenseViewState = .loading
    private let interactor: LicenseInteractor
    private let reducer = LicenseReducer()
    
    init(interactor: LicenseInteractor) {
        self.interactor = interactor
    }
    
    func send(_ event: LicenseViewEvent) async {
        switch event {
        case .load:
            await react(domainAction: .load)
        }
    }
}

// MARK: - Private

private extension LicenseViewModel {
    func updateViewState(_ viewState: LicenseViewState) async {
        await MainActor.run {
            self.viewState = viewState
        }
    }
    
    func react(domainAction: LicenseDomainAction) async {
        let domain = await interactor.interact(with: domainAction)
        let newViewState = reducer.reduce(domain)
        await updateViewState(newViewState)
    }
}
