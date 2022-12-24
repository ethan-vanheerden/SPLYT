//
//  WorkoutsDisplayInfo.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Core
import DesignSystem

struct WorkoutsDisplayInfo: Equatable {
    static func == (lhs: WorkoutsDisplayInfo, rhs: WorkoutsDisplayInfo) -> Bool {
        return false // TODO
    }
    
    
    let mainItems: [ItemViewState]
    let fabItems: [FABRowViewState]
}
