//
//  LoginInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

// MARK: - Domain Actions

enum LoginDomainAction {
    case load
}

// MARK: - Domain Results

enum LoginDomainResult: Equatable {
    case error
    case loaded(LoginDomain)
}

// MARK: - Interactor

final class LoginInteractor {
    private let service: LoginServiceType
    private var savedDomain: LoginDomain?
    
    init(service: LoginServiceType = LoginService()) {
        self.service = service
    }
    
    func interact(with action: LoginDomainAction) async -> LoginDomainResult {
        switch action {
        case .load:
            return handleLoad()
        }
    }
}

// MARK: - Private Handlers

private extension LoginInteractor {
    func handleLoad() -> LoginDomainResult {
        do {
            
        } catch {
            return .error
        }
    }
}

// MARK: - Other Private Helpers

private extension LoginInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: LoginDomain) -> LoginDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
}
