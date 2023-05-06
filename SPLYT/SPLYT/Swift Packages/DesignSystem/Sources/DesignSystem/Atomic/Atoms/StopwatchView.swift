import SwiftUI

public struct StopwatchView: View {
    @Binding private var secondsElapsed: Int
    
    public init(secondsElapsed: Binding<Int>) {
        self._secondsElapsed = secondsElapsed
        _ = timer
    }
    
    public var body: some View {
        Text("\(hours):\(minutes):\(seconds)")
            .title1()
    }
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            secondsElapsed += 1
        }
    }
    
    private var hours: Int {
        secondsElapsed / 3600
    }

    private var minutes: Int {
      (secondsElapsed % 3600) / 60
    }

    private var seconds: Int {
        secondsElapsed % 60
    }
}

