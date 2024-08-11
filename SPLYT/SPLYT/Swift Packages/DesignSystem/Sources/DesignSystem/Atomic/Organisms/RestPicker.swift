import SwiftUI

public struct RestPicker: View {
    @Binding private var minutes: Int
    @Binding private var seconds: Int
    @EnvironmentObject private var userTheme: UserTheme
    private let confirmAction: () -> Void
    private let cancelAction: () -> Void
    
    public init(minutes: Binding<Int>,
                seconds: Binding<Int>,
                confirmAction: @escaping () -> Void,
                cancelAction: @escaping () -> Void) {
        self._minutes = minutes
        self._seconds = seconds
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Counter(selectedNumber: $minutes,
                        viewState: .init(maxNumber: 10,
                                         label: Strings.min))
                Counter(selectedNumber: $seconds,
                        viewState: .init(maxNumber: 59,
                                         label: Strings.sec))
            }
            Spacer()
            pickerButtons
        }
    }
    
    private var pickerButtons: some View {
        HStack(spacing: Layout.size(2)) {
            SplytButton(text: Strings.cancel,
                        type: .textOnly(fillsSpace: true),
                        textColor: .label) {
                cancelAction()
            }
            SplytButton(text: Strings.confirm,
                        isEnabled: !(seconds == 0 && minutes == 0)) {
                confirmAction()
            }
        }
        .padding(.horizontal, Layout.size(2))
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let min = "min"
    static let sec = "sec"
    static let cancel = "Cancel"
    static let confirm = "Confirm"
}
