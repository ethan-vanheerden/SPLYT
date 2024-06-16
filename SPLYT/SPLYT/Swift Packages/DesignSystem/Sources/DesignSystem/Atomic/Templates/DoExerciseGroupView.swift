import SwiftUI
import ExerciseCore

public struct DoExerciseGroupView: View {
    @Binding private var isExpanded: Bool
    private let viewState: DoExerciseGroupViewState
    private let addSetAction: () -> Void
    private let removeSetAction: () -> Void
    private let updateSetAction: (Int, Int, SetInput) -> Void // Exercise index, set index, input
    private let updateModifierAction: (Int, Int, SetInput) -> Void // Exercise index, set index, input
    private let usePreviousInputAction: (Int, Int, Bool) -> Void // Exercise index, set index, for a modifier
    private let addNoteAction: () -> Void
    private let finishSlideAction: () -> Void
    private let replaceExerciseAction: (Int) -> Void // Exercise index
    private let deleteExerciseAction: (Int) -> Void // Exercise index
    private let canDeleteExercise: Bool
    
    public init(isExpanded: Binding<Bool>,
                viewState: DoExerciseGroupViewState,
                addSetAction: @escaping () -> Void,
                removeSetAction: @escaping () -> Void,
                updateSetAction: @escaping (Int, Int, SetInput) -> Void,
                updateModifierAction: @escaping (Int, Int, SetInput) -> Void,
                usePreviousInputAction: @escaping (Int, Int, Bool) -> Void,
                addNoteAction: @escaping () -> Void,
                finishSlideAction: @escaping () -> Void,
                replaceExerciseAction: @escaping (Int) -> Void,
                deleteExerciseAction: @escaping (Int) -> Void,
                canDeleteExercise: Bool) {
        self._isExpanded = isExpanded
        self.viewState = viewState
        self.addSetAction = addSetAction
        self.removeSetAction = removeSetAction
        self.updateSetAction = updateSetAction
        self.updateModifierAction = updateModifierAction
        self.usePreviousInputAction = usePreviousInputAction
        self.addNoteAction = addNoteAction
        self.finishSlideAction = finishSlideAction
        self.replaceExerciseAction = replaceExerciseAction
        self.deleteExerciseAction = deleteExerciseAction
        self.canDeleteExercise = canDeleteExercise
    }
    
    
    public var body: some View {
        VStack {
            CollapseHeader(isExpanded: $isExpanded,
                           viewState: viewState.header) {
                VStack {
                    ForEach(Array(viewState.exercises.enumerated()), id: \.offset) { exerciseIndex, exercise in
                        ExerciseView(viewState: exercise,
                                     type: .inProgress(
                                        usePreviousInputAction: { setIndex, fromModifier in
                                            usePreviousInputAction(exerciseIndex, setIndex, fromModifier)
                                        },
                                        addNoteAction: addNoteAction,
                                        replaceExerciseAction: {
                                            replaceExerciseAction(exerciseIndex)
                                        },
                                        deleteExerciseAction: {
                                            deleteExerciseAction(exerciseIndex)
                                        },
                                        canDeleteExercise: canDeleteExercise
                                     ),
                                     addSetAction: addSetAction,
                                     removeSetAction: removeSetAction,
                                     updateSetAction: { setIndex, newInput in
                            updateSetAction(exerciseIndex, setIndex, newInput)
                        },
                                     updateModifierAction: { setIndex, newInput in
                            updateModifierAction(exerciseIndex, setIndex, newInput)
                        })
                    }
                    .padding(.bottom, Layout.size(1))
                    if let slider = viewState.slider {
                        ActionSlider(viewState: slider,
                                     finishSlideAction: finishSlideAction)
                        .padding(.horizontal, Layout.size(1))
                        .padding(.bottom, Layout.size(2))
                    }
                }
            }
        }
    }
}

// MARK: - View State

public struct DoExerciseGroupViewState: Equatable {
    let header: CollapseHeaderViewState
    public let exercises: [ExerciseViewState]
    let slider: ActionSliderViewState? // Not shown once completed
    
    public init(header: CollapseHeaderViewState,
                exercises: [ExerciseViewState],
                slider: ActionSliderViewState?) {
        self.header = header
        self.exercises = exercises
        self.slider = slider
    }
}
