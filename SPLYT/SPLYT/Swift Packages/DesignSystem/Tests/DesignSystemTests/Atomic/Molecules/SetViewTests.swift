import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

final class SetViewTests: XCTestCase {
    func testSetView() {
        let view = VStack {
            SetView(viewState: SetViewState(setIndex: 0,
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              weight: 135,
                                                              repsTitle: "reps")),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 1,
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              weight: 135,
                                                              repsTitle: "reps",
                                                              reps: 12),
                                            modifier: .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                                weight: 100,
                                                                                repsTitle: "reps"))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 2,
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps",
                                                            reps: 8)),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 3,
                                            title: "Set 4",
                                            type: .time(title: "sec",
                                                        seconds: 30)),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 4,
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps"),
                                            modifier: .eccentric),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 5,
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps", reps: 12),
                                            modifier: .restPause(set: .repsOnly(title: "reps"))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
