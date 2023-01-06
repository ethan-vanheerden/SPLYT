//
//  NameWorkoutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import SwiftUI
import DesignSystem

// TODO: nav bar in Design System
struct NameWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button("Back") {
            dismiss()
        }
    }
}

struct NameWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NameWorkoutView()
    }
}
