import SwiftUI
import DesignSystem

struct RestFABGallery: View {
    @State private var isPresenting = false
    private let restPresets: [Int] = [60, 90, 120]
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().eraseToAnyPublisher()
    
    var body: some View {
        ZStack {
//            RestFAB(isPresenting: $isPresenting,
//                    viewState: viewState,
//                    timer: timer,
//                    selectRestAction: { _ in },
//                    selectMoreAction: { },
//                    stopAction: { })
        }
    }
    
//    private var viewState: RestFABViewState {
//        return RestFABViewState(restPresets: restPresets)
//    }
}
