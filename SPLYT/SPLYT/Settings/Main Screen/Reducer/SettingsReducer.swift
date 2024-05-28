//
//  SettingsReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import Foundation
import DesignSystem

struct SettingsReducer {
    func reduce(_ domain: SettingsDomainResult) -> SettingsViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        case let .dialog(type, domain):
            let display = getDisplay(domain: domain, dialog: type)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension SettingsReducer {
    func getDisplay(domain: SettingsDomain, dialog: SettingsDialog? = nil) -> SettingsDisplay {
        return .init(sections: domain.sections,
                     versionString: domain.versionString,
                     buildNumberString: domain.buildNumberString,
                     shownDialog: dialog,
                     signOutDialog: signOutDialog)
    }
    
    var signOutDialog: DialogViewState {
        return .init(title: Strings.confirmSignOut,
                     subtitle: Strings.areYouSure,
                     primaryButtonTitle: Strings.signOut,
                     secondaryButtonTitle: Strings.cancel)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let confirmSignOut = "Confirm Sign Out"
    static let areYouSure = "Are you sure you want to sign out?"
    static let signOut = "Sign Out"
    static let cancel = "Cancel"
}
