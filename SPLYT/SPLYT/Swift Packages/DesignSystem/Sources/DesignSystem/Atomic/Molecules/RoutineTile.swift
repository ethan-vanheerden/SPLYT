import SwiftUI

public struct RoutineTile: View {
    @State private var showActionSheet: Bool = false
    private let viewState: RoutineTileViewState
    private let tapAction: () -> Void
    private let editAction: () -> Void
    private let deleteAction: () -> Void
    
    public init(viewState: RoutineTileViewState,
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
                    Text(viewState.title)
                        .body()
                    Text(viewState.subtitle)
                        .subhead()
                        .foregroundColor(.init(splytColor: .lightBlue))
                    if let lastCompleted = viewState.lastCompletedTitle {
                        Text(lastCompleted)
                            .footnote()
                            .foregroundColor(.init(splytColor: .gray))
                    }
                }
                Spacer()
                if viewState.includeIcon {
                    IconButton(iconName: "ellipsis",
                               style: .secondary,
                               iconColor: .black) { showActionSheet = true }
                }
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

public struct RoutineTileViewState: Hashable {
    public let id: String
    public let historyFilename: String? // Where this routine's history is cached, if it is
    let title: String
    let subtitle: String
    let lastCompletedTitle: String?
    let includeIcon: Bool // For edit and delete actions
    
    public init(id: String,
                historyFilename: String? = nil,
                title: String,
                subtitle: String,
                lastCompletedTitle: String? = nil,
                includeIcon: Bool = true) {
        self.id = id
        self.historyFilename = historyFilename
        self.title = title
        self.subtitle = subtitle
        self.lastCompletedTitle = lastCompletedTitle
        self.includeIcon = includeIcon
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let edit = "Edit"
    static let delete = "Delete"
}
