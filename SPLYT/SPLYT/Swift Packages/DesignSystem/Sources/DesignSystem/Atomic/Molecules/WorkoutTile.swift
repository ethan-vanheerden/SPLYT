import SwiftUI

public struct WorkoutTile: View {
    @State private var showActionSheet: Bool = false
    private let viewState: WorkoutTileViewState
    private let tapAction: () -> Void
    private let editAction: () -> Void
    private let deleteAction: () -> Void
    
    public init(viewState: WorkoutTileViewState,
                tapAction: @escaping () -> Void,
                editAction: @escaping () -> Void,
                deleteAction: @escaping () -> Void) {
        self.viewState = viewState
        self.tapAction = tapAction
        self.editAction = editAction
        self.deleteAction = deleteAction
    }
    
    public var body: some View {
        Tile {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewState.workoutName)
                        .body()
                    Text(viewState.numExercises)
                        .subhead()
                        .foregroundColor(.init(splytColor: .lightBlue))
                    if let lastCompleted = viewState.lastCompleted {
                        Text(lastCompleted)
                            .footnote()
                            .foregroundColor(.init(splytColor: .gray))
                    }
                }
                Spacer()
                IconButton(iconName: "ellipsis",
                           style: .secondary,
                           iconColor: .black) { showActionSheet = true }
            }
            .frame(height: Layout.size(6)) // Fixed height even if there is no last completed
            .padding(.horizontal, Layout.size(1))
        }
        .onTapGesture {
            tapAction()
        }
        .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
            // These just have to be normal buttons
            Button(Strings.edit) { editAction() }
            Button(Strings.delete, role: .destructive) { deleteAction() }
        }
    }
}

// MARK: - View State

public struct WorkoutTileViewState: Hashable {
    public let id: String // Workout ID
    public let filename: String? // Where the workout's history is cached
    let workoutName: String
    let numExercises: String
    let lastCompleted: String?
    
    public init(id: String,
                filename: String? = nil,
                workoutName: String,
                numExercises: String,
                lastCompleted: String? = nil) {
        self.id = id
        self.filename = filename
        self.workoutName = workoutName
        self.numExercises = numExercises
        self.lastCompleted = lastCompleted
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let edit = "Edit"
    static let delete = "Delete"
}

