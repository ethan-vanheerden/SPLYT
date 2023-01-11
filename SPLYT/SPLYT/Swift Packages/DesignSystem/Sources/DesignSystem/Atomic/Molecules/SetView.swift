import SwiftUI

public struct SetView: View {
    private let viewState: SetViewState
    // AnyHashable to represent the setId, Double to represent the new value
    private let updateAction: (AnyHashable, Double) -> Void // TODO: Will other input types require a different send type here?
    private let horizontalPadding = Layout.size(4)

    public init(viewState: SetViewState,
                updateAction: @escaping (AnyHashable, Double) -> Void) {
        self.viewState = viewState
        self.updateAction = updateAction
    }

    public var body: some View {
        ZStack {
            entries
            HStack {
                Spacer()
                tagView
                    .padding(.trailing, horizontalPadding)
            }
            HStack {
                Text(viewState.title)
                    .bodyText()
                    .padding(.bottom, Layout.size(2))
                    .padding(.leading, horizontalPadding)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var entries: some View {
        switch viewState.type {
        case let .repsWeight(weightTitle, weightPlaceholder, repsTitle, repsPlaceholder):
            HStack(spacing: Layout.size(4)) {
                setEntry(title: repsTitle, placeholder: repsPlaceholder, inputType: .reps)
                setEntry(title: weightTitle, placeholder: weightPlaceholder, inputType: .weight)
            }
        case let .repsOnly(title, placeholder):
            setEntry(title: title, placeholder: placeholder, inputType: .reps)
        case let .time(title, placeholder):
            setEntry(title: title, placeholder: placeholder, inputType: .reps) // TODO: add .time input type
        }
    }
    
    @ViewBuilder
    private func setEntry(title: String, placeholder: String?, inputType: SetEntryType) -> some View {
        SetEntry(id: viewState.id,
                 title: title,
                 placeholder: placeholder,
                 inputType: inputType,
                 doneAction: updateAction)
    }
    
    @ViewBuilder
    private var tagView: some View {
        if let tag = viewState.tag {
            tag.tag
                .padding(.bottom, Layout.size(2))
        } else {
            EmptyView()
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SetView(viewState: SetViewState(id: "id-1",
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs", weightPlaceholder: "135", repsTitle: "reps"))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-2",
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs", weightPlaceholder: "135", repsTitle: "reps", repsPlaceholder: "225"),
                                            tag: .dropSet)) { _, _ in }
            SetView(viewState: SetViewState(id: "id-3",
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps", placeholder: "8"))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-4",
                                            title: "Set 4",
                                            type: .time(title: "sec", placeholder: "30"))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-5",
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps"),
                                            tag: .eccentric)) { _, _ in }
            SetView(viewState: SetViewState(id: "id-6",
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps", placeholder: "12"),
                                            tag: .restPause)) { _, _ in }
        }
    }
}

// MARK: - View State

public struct SetViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let title: String
    let type: SetViewType
    let tag: SetTag?

    public init(id: AnyHashable,
                title: String,
                type: SetViewType,
                tag: SetTag? = nil) {
        self.id = id
        self.title = title
        self.type = type
        self.tag = tag
    }
}

// MARK: - Set Type

public enum SetViewType: Equatable {
    case repsWeight(weightTitle: String, weightPlaceholder: String? = nil, repsTitle: String, repsPlaceholder: String? = nil)
    case repsOnly(title: String, placeholder: String? = nil)
    case time(title: String, placeholder: String? = nil)
}
