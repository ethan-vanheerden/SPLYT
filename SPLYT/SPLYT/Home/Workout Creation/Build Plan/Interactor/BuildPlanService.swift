//
//  BuildPlanService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/18/23.
//

import Foundation
import ExerciseCore
import Caching

// MARK: - Protocol

protocol BuildPlanServiceType {
    func savePlan(_: Plan) throws
}

// MARK: - Implementation

struct BuildPlanService: BuildPlanServiceType {
    private let routineService: CreatedRoutinesServiceType
    
    init(routineService: CreatedRoutinesServiceType = CreatedRoutinesService()) {
        self.routineService = routineService
    }
    
    func savePlan(_ plan: Plan) throws {
        try routineService.savePlan(plan)
    }
}
