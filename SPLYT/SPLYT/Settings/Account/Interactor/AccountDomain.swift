//
//  AccountDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

struct AccountDomain: Equatable {
    let items: [AccountItem]
    var isDeleting: Bool
}

// MARK: - Dialogs

enum AccountDialog: Equatable {
    case signOut
    case deleteAccount
}
