//
//  RestPresetsViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import Foundation

enum RestPresetsViewState: Equatable {
    case loading
    case error
    case loaded(RestPresetsDisplay)
}
