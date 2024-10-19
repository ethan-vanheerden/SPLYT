//
//  AccountViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/17/24.
//

enum AccountViewState: Equatable {
    case loading
    case error
    case loaded(AccountDisplay)
}
