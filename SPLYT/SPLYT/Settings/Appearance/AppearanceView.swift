//
//  AppearanceView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/15/24.
//

import Foundation
import SwiftUI
import DesignSystem

struct AppearanceView: View {
    @AppStorage("userTheme") private var userTheme: SplytColor = .lightBlue
    @Namespace private var animation
    private let colorThemeColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    var body: some View {
        Form {
            Section {
                colorTheme
            } header: {
                Text("Color Theme")
                    .subhead()
            }
            Section {
                Text("App icon")
            } header: {
                Text("App icon")
                    .subhead()
            }
        }
    }
    
    @ViewBuilder
    private var colorTheme: some View {
        LazyVGrid(columns: colorThemeColumns) {
            ForEach(SplytColor.userThemes, id: \.self) { color in
                Circle()
                    .fill(color.color.gradient)
                    .overlay {
                        Image(systemName: "checkmark")
                            .imageScale(.large)
                            .foregroundStyle(Color(splytColor: .white))
                            .isVisible(userTheme == color)
                    }
                    .onTapGesture {
                        userTheme = color
                    }
            }
        }
    }
}
