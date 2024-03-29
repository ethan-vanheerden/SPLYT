//
//  DoPlanService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/4/23.
//

import Foundation
import ExerciseCore
import Caching

// MARK: - Protocol

protocol DoPlanServiceType {
    func loadPlan(planId: String) throws -> Plan
    func deleteWorkout(planId: String, workoutId: String) throws
}

// MARK: - Implementation

struct DoPlanService: DoPlanServiceType {
    private let routineService: CreatedRoutinesServiceType
    
    init(routineService: CreatedRoutinesServiceType = CreatedRoutinesService()) {
        self.routineService = routineService
    }
    
    func loadPlan(planId: String) throws -> Plan {
        return try routineService.loadPlan(id: planId)
    }
    
    func deleteWorkout(planId: String, workoutId: String) throws {
        try routineService.deleteWorkout(fromPlanId: planId,
                                         workoutId: workoutId)
    }
}

