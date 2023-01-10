//
//  AddExerciseView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import SwiftUI
import DesignSystem

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Add your exercises")
            .navigationBar(state: NavigationBarViewState(title: "ADD EXERCISES")) {
                dismiss()
            }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}

// MARK: - String Constants

fileprivate struct Strings {
//    static let addYourExercises = "ADD EXERCISES"
}
