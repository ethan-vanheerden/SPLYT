//
//  LicenseReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation
import DesignSystem

struct LicenseReducer {
    func reduce(_ domainResult: LicenseDomainResult) -> LicenseViewState {
        switch domainResult {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension LicenseReducer {
    func getDisplay(domain: LicenseDomain) -> LicenseDisplay {
        let listItems: [SettingsListItemViewState] = domain.licenses.map { license in
            return .init(title: license.title,
                         iconName: "link",
                         iconBackgroundColor: .gray,
                         link: license.licenseURL)
        }
        return .init(licenses: listItems)
    }
}
