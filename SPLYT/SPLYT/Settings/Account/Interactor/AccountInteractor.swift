//
//  AccountInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

// MARK: - Domain Actions

enum AccountDomainAction {
    case load
    case signOut
    case submitDeleteAccount
    case deleteAccount
    case toggleDialog(type: AccountDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum AccountDomainResult: Equatable {
    case error
    case loaded(AccountDomain)
    case dialog(AccountDialog, domain: AccountDomain)
}

// MARK: - Interactor

final class AccountInteractor {
    private let service: AccountServicing
    private var savedDomain: AccountDomain?
    
    init(service: AccountServicing) {
        self.service = service
    }
    
    func interact(with action: AccountDomainAction) async -> AccountDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .signOut:
            return handleSignOut()
        case .submitDeleteAccount:
            return handleSubmitDeleteAccount()
        case .deleteAccount:
            return await handleDeleteAccount()
        case let .toggleDialog(type, isOpen):
            return handleToggleDialog(type: type, isOpen: isOpen)
        }
    }
}

// MARK: - Private Handlers

private extension AccountInteractor {
    func handleLoad() -> AccountDomainResult {
        let domain = AccountDomain(items: AccountItem.allCases,
                                   isDeleting: false)
        return updateDomain(domain: domain)
    }
    
    func handleSignOut() -> AccountDomainResult {
        guard let domain = savedDomain else { return .error }
        
        let didSignOut = service.signOut()
        
        return didSignOut ? updateDomain(domain: domain) : .error
    }
    
    func handleSubmitDeleteAccount() -> AccountDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.isDeleting = true
        
        return updateDomain(domain: domain)
    }
    
    func handleDeleteAccount() async -> AccountDomainResult {
        guard var domain = savedDomain else { return .error }
        
        let didDeleteAccount = await service.deleteUser()
        // Sign out to bring back to login screen
        let signedOut = service.signOut()
        
        domain.isDeleting = false
        
        return didDeleteAccount && signedOut ? updateDomain(domain: domain) : .error
    }
    
    func handleToggleDialog(type: AccountDialog, isOpen: Bool) -> AccountDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(type, domain: domain) : .loaded(domain)
    }
}

// MARK: - Other Private Helpers

private extension AccountInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: AccountDomain) -> AccountDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
}
