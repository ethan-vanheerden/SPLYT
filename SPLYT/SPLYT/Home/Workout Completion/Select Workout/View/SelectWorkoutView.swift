//
//  SelectWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/5/23.
//

import SwiftUI
import DesignSystem

struct SelectWorkoutView: View {
    private let dismissAction: () -> Void
    
    init(dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        Text("Select Workout View")
            .body()
            .navigationBar(viewState: NavigationBarViewState(title: "Workout Name: TODO",
                                                             size: .large,
                                                             position: .center),
                           backAction: dismissAction)
    }
}
