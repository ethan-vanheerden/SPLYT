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
    private let header: CollapseHeaderViewState = .init(title: "Group 1",
                                                        color: .lightBlue)
    private let exercises: [ExerciseViewState] = StateFixtures.legWorkoutExercisesPlaceholders(includeHeaderLine: false)[0]
    private let slider: ActionSliderViewState = .init(sliderColor: .lightBlue,
                                                      backgroundText: "Mark as complete")
    private var viewState: DoExerciseGroupViewState {
        return .init(header: header,
                     exercises: exercises,
                     slider: slider)
    }
    
    func testDoExerciseGroupView() {
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
