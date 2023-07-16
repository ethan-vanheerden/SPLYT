//
//  HistoryViewState.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation

enum HistoryViewState: Equatable {
    case loading
    case error
    case loaded(HistoryDisplay)
}
