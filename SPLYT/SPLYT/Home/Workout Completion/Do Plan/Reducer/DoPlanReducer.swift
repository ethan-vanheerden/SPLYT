//
//  DoPlanReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation

struct DoPlanReducer {
    func reduce(_ domain: DoPlanDomainResult) -> DoPlanViewState {
        return .error
    }
}

// MARK: - Private

private extension DoPlanReducer {
    func getDisplay(domain: DoPlanDomain) -> DoPlanDisplay {
        return .init()
    }
}
