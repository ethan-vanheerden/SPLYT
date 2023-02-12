import SwiftUI

public struct BuildExerciseView: View {
    private let viewState: BuildExerciseViewState
    private let addSetAction: () -> Void
    private let removeSetAction: () -> Void
    private let addModiferAction: () -> Void
    private let updateAction: (AnyHashable, Double) -> Void
    
    public init(viewState: BuildExerciseViewState,
                addSetAction: @escaping () -> Void,
                removeSetAction: @escaping () -> Void,
                addModiferAction: @escaping () -> Void,
                updateAction: @escaping (AnyHashable, Double) -> Void) {
        self.viewState = viewState
        self.addSetAction = addSetAction
        self.removeSetAction = removeSetAction
        self.addModiferAction = addModiferAction
        self.updateAction = updateAction
    }
    
    public var body: some View {
        VStack {
            SectionHeader(viewState: viewState.header)
                .padding(.horizontal, Layout.size(2))
            ForEach(viewState.sets, id: \.id) { set in
                SetView(viewState: set, updateAction: updateAction)
            }
            setButtons
        }
    }
    
    @ViewBuilder
    private var setButtons: some View {
        HStack(spacing: Layout.size(5)) {
            Button(action: addSetAction) {
                Text("Add Set")
                    .bodyText()
                    .foregroundColor(Color.splytColor(.lightBlue))
            }
            Button(action: removeSetAction) {
                Text("Remove Set")
                    .bodyText()
                    .foregroundColor(Color.splytColor(.lightBlue))
            }
            Button(action: { }) {
                Text("Add Modifer")
                    .bodyText()
                    .foregroundColor(Color.splytColor(.lightBlue))
            }
            Spacer()
        }
        .padding(.leading, Layout.size(4))
    }
}

// MARK: View State

public struct BuildExerciseViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let header: SectionHeaderViewState
    let sets: [SetViewState]
    
    public init(id: AnyHashable,
                header: SectionHeaderViewState,
                sets: [SetViewState]) {
        self.id = id
        self.header = header
        self.sets = sets
    }
}
