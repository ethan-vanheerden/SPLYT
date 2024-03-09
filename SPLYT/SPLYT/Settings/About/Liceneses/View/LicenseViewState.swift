//
//  LicenseViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation

enum LicenseViewState: Equatable {
    case loading
    case error
    case loaded(LicenseDisplay)
}
