//
//  CreatedWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/1/23.
//

import SwiftUI
import DesignSystem

struct CreatedWorkoutView: View {
    @State private var showActionSheet: Bool = false
    private let viewState: CreatedWorkoutViewState
    private let tapAction: (String) -> Void
    private let editAction: (String) -> Void
    private let deleteAction: (String) -> Void
    
    init(viewState: CreatedWorkoutViewState,
         tapAction: @escaping (String) -> Void,
         editAction: @escaping (String) -> Void,
         deleteAction: @escaping (String) -> Void) {
        self.tapAction = tapAction
        self.viewState = viewState
        self.editAction = editAction
        self.deleteAction = deleteAction
    }
    
    var body: some View {
        Tile {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewState.title)
                        .body()
                    Text(viewState.subtitle)
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
            tapAction(viewState.id)
        }
        .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
            // These just have to be normal buttons
            Button(Strings.edit) { editAction(viewState.id) }
            Button(Strings.delete, role: .destructive) { deleteAction(viewState.id) }
        }
    }
}


// MARK: - View State

struct CreatedWorkoutViewState: Equatable {
    let id: String
    let title: String
    let subtitle: String
    let lastCompleted: String?
}

// MARK: - String Constants

fileprivate struct Strings {
    static let edit = "Edit"
    static let delete = "Delete"
}

struct CreatedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CreatedWorkoutView(viewState: CreatedWorkoutViewState(id: "workout-legs-1",
                                                                  title: "Legs",
                                                                  subtitle: "5 exercises",
                                                                  lastCompleted: "Last completed: 3/1/2023"),
                               tapAction: { _ in },
                               editAction: { _ in },
                               deleteAction: { _ in })
            CreatedWorkoutView(viewState: CreatedWorkoutViewState(id: "workout-legs-1",
                                                                  title: "Legs",
                                                                  subtitle: "5 exercises",
                                                                  lastCompleted: nil),
                               tapAction: { _ in },
                               editAction: { _ in },
                               deleteAction: { _ in })
        }
    }
}
