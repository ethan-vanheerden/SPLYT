import SwiftUI

public struct StopwatchView: View {
    @Binding private var secondsElapsed: Int
    
    public init(secondsElapsed: Binding<Int>) {
        self._secondsElapsed = secondsElapsed
        _ = timer
    }
    
    public var body: some View {
        Text(TimeUtils.hrMinSec(seconds: secondsElapsed))
            .title1()
    }
    
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            secondsElapsed += 1
        }
    }
}
