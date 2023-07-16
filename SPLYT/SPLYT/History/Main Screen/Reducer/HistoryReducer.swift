//
//  HistoryReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import DesignSystem

struct HistoryReducer {
    func reduce(_ domain: HistoryDomainResult) -> HistoryViewState {
        return .error
    }
}

// MARK: - Private

private extension HistoryReducer {
    func getDisplay(domain: HistoryDomain) -> HistoryDisplay {
        return .init()
    }
}
