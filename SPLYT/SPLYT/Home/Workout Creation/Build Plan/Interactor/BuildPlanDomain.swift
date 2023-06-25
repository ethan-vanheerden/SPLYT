//
//  BuildPlanDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import ExerciseCore

final class BuildPlanDomain: Equatable {
    var builtPlan: Plan
    var canSave: Bool
    
    init(builtPlan: Plan,
         canSave: Bool) {
        self.builtPlan = builtPlan
        self.canSave = canSave
    }
    
    static func == (lhs: BuildPlanDomain, rhs: BuildPlanDomain) -> Bool {
        return lhs.builtPlan == rhs.builtPlan &&
        lhs.canSave == rhs.canSave
    }
}


// MARK: - Dialogs

enum BuildPlanDialog: Equatable {
    case back
    case save
    case deleteWorkout(id: String)
}
