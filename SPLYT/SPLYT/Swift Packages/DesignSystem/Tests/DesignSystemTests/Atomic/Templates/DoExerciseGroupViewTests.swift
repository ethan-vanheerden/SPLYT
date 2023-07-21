//
//  DoExerciseGroupTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/13/23.
//

import XCTest
@testable import DesignSystem
import SwiftUI
import SnapshotTesting

final class DoExerciseGroupViewTests: XCTestCase {
    typealias StateFixtures = WorkoutViewStateFixtures
    
    func testDoExerciseGroupView() {
        let header = CollapseHeaderViewState(title: "Group 1",
                                            color: .lightBlue)
        let exercises = StateFixtures.legWorkoutExercisesPlaceholders(includeHeaderLine: false)[0]
        let slider = ActionSliderViewState(sliderColor: .lightBlue,
                                          backgroundText: "Mark as complete")
        let viewState = DoExerciseGroupViewState(header: header,
                                                 exercises: exercises,
                                                 slider: slider)
        
        let view = VStack {
            DoExerciseGroupView(isExpanded: .constant(true),
                                viewState: viewState,
                                addSetAction: { },
                                removeSetAction: { },
                                updateSetAction: { _, _, _ in },
                                updateModifierAction: { _, _, _ in },
                                usePreviousInputAction: { _, _, _ in },
                                addNoteAction: { },
                                finishSlideAction: { })
            DoExerciseGroupView(isExpanded: .constant(false),
                                viewState: viewState,
                                addSetAction: { },
                                removeSetAction: { },
                                updateSetAction: { _, _, _ in },
                                updateModifierAction: { _, _, _ in },
                                usePreviousInputAction: { _, _, _ in },
                                addNoteAction: { },
                                finishSlideAction: { })
        }
            .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
