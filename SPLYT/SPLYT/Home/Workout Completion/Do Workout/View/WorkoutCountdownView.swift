//
//  WorkoutCountdownView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/20/23.
//

import SwiftUI

/// Simple view which does not need the view model
struct WorkoutCountdownView: View {
    @State private var countdownSeconds: Int = 3
    @Environment(\.dismiss) private var dismiss
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let navigationRouter: DoWorkoutNavigationRouter
    
    init(navigationRouter: DoWorkoutNavigationRouter) {
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(countdownSeconds)")
                    .largeTitle()
                Text("Enjoy your lift 🏋️!")
                    .title1()
                Spacer()
            }
            .foregroundColor(Color(splytColor: .white))
            Spacer()
        }
        .background(LinearGradient(colors: [Color(splytColor: .purple),
                                            Color(splytColor: .lightBlue)], // TODO: 45: gradients
                                   startPoint: .bottom, endPoint: .top))
        .onReceive(timer) { _ in
            if countdownSeconds <= 0 {
//                timer.upstream.connect().cancel() // Stop the timer so we don't keep pushing the view
                dismiss()
                navigationRouter.navigate(.beginWorkout)
            } else {
                countdownSeconds -= 1
            }
        }
    }
}
