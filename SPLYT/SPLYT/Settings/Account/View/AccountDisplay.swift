//
//  AccountDisplay.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

import DesignSystem

struct AccountDisplay: Equatable {
    let items: [AccountItem]
    let isDeleting: Bool
    let shownDialog: AccountDialog?
    let signOutDialog: DialogViewState
    let deleteAccountDialog: DialogViewState
}
