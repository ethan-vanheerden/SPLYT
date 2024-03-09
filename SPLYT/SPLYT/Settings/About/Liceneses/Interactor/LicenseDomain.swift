//
//  LicenseDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation

struct LicenseDomain: Equatable {
    let licenses: [License]
}

struct License: Equatable {
    let title: String
    let licenseURL: URL
}
