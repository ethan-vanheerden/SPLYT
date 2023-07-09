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
}

// MARK: - Implementation

struct DoPlanService: DoPlanServiceType {
    private let cacheInteractor: CacheInteractorType
    private let routineService: CreatedRoutinesServiceType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService()) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
    }
    
    func loadPlan(planId: String) throws -> Plan {
        return try routineService.loadPlan(id: planId)
    }
}

