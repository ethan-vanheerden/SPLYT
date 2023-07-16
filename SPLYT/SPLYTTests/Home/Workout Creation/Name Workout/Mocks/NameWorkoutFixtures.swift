//
//  File.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import Foundation
import DesignSystem

struct NameWorkoutFixtures {
    // MARK: - View States
    
    static let workoutNavBar: NavigationBarViewState = .init(title: "CREATE WORKOUT")
    
    static let planNavBar: NavigationBarViewState = .init(title: "CREATE PLAN")
    
    static let workoutTextEntry: TextEntryViewState = .init(title: "Workout Name",
                                                            placeholder: "Enter a workout name")
    
    static let planTextEntry: TextEntryViewState = .init(title: "Plan Name",
                                                         placeholder: "Enter a plan name")
}
