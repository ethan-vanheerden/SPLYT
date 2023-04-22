//
//  BuildWorkoutTransformer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 4/14/23.
//

import Foundation
import DesignSystem
import ExerciseCore

/// Used to transform view states into models from the view, like the opposite of a reducer.
/// This is so that our View Model does not know what the view states look like.
struct BuildWorkoutTransformer {
    func transformModifier(_ modifier: SetModifierViewState) -> SetModifier {
        switch modifier {
        case .dropSet(let set):
            return .dropSet(input: transformSetInput(set))
        case .restPause(let set):
            return .restPause(input: transformSetInput(set))
        case .eccentric:
            return .eccentric
        }
    }
}

// MARK: - Private

private extension BuildWorkoutTransformer {
    func transformSetInput(_ set: SetInputViewState) -> SetInput {
        switch set {
        case let .repsWeight(_, weight, _, reps):
            return .repsWeight(reps: reps, weight: weight)
        case let .repsOnly(_, reps):
            return .repsOnly(reps: reps)
        case let .time(_, seconds):
            return .time(seconds: seconds)
        }
    }
}
