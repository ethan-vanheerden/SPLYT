import XCTest
@testable import DesignSystem
import SwiftUI
import SnapshotTesting

final class CompletedExerciseGroupViewTests: XCTestCase {
    typealias StateFixtures = WorkoutViewStateFixtures
    
    func testCompletedExerciseGroupView() {
        let header = CollapseHeaderViewState(title: "Group 1",
                                             color: .lightBlue)
        let exercises = StateFixtures.fullBodyWorkoutExercisesCompleted(includeHeaderLine: false)[0]
        let viewState = CompletedExerciseGroupViewState(header: header,
                                                        exercises: exercises)
        let view = VStack {
            CompletedExerciseGroupView(isExpanded: .constant(true),
                                       viewState: viewState)
            CompletedExerciseGroupView(isExpanded: .constant(false),
                                       viewState: viewState)
        }
            .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
