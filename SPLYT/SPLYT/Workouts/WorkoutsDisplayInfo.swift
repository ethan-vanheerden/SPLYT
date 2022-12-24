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
    let mainItems: [ItemViewStateWrapper]
    let fabItems: [FABRowViewState]
}
