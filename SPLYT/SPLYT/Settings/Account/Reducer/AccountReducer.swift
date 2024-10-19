//
//  AccountReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

import DesignSystem

struct AccountReducer {
    func reduce(_ domainResult: AccountDomainResult) -> AccountViewState {
        switch domainResult {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case let .dialog(dialog, domain):
            let display = getDisplay(domain: domain, dialog: dialog)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension AccountReducer {
    func getDisplay(domain: AccountDomain, dialog: AccountDialog? = nil) -> AccountDisplay {
        return .init(items: domain.items,
                     isDeleting: domain.isDeleting,
                     shownDialog: dialog,
                     signOutDialog: signOutDialog,
                     deleteAccountDialog: deleteAccountDialog)
    }
    
    var signOutDialog: DialogViewState {
        return .init(title: Strings.confirmSignOut,
                     subtitle: Strings.areYouSure,
                     primaryButtonTitle: Strings.signOut,
                     secondaryButtonTitle: Strings.cancel)
    }
    
    var deleteAccountDialog: DialogViewState {
        return .init(title: Strings.deleteAccount,
                     subtitle: Strings.cannotBeUndone,
                     primaryButtonTitle: Strings.delete,
                     secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let confirmSignOut = "Confirm Sign Out"
    static let areYouSure = "Are you sure you want to sign out?"
    static let signOut = "Sign Out"
    static let cancel = "Cancel"
    static let deleteAccount = "Delete Account?"
    static let cannotBeUndone = "This action cannot be undone."
    static let delete = "Delete"
}
