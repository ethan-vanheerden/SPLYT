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
    @StateObject private var viewModel = AppearanceViewModel()
    private let colorThemeColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    private let appIconColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        Form {
            Section {
                colorThemes
            } header: {
                Text(Strings.colorTheme)
                    .subhead()
            }
            Section {
                appIcons
            } header: {
                Text(Strings.appIcon)
                    .subhead()
            }
        }
    }
    
    @ViewBuilder
    private var colorThemes: some View {
        LazyVGrid(columns: colorThemeColumns) {
            ForEach(SplytColor.userThemes, id: \.self) { color in
                Circle()
                    .fill(color.color.gradient)
                    .overlay {
                        Image(systemName: "checkmark")
                            .imageScale(.large)
                            .foregroundStyle(Color(SplytColor.white))
                            .isVisible(viewModel.userTheme == color)
                    }
                    .onTapGesture {
                        viewModel.updateUserTheme(to: color)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var appIcons: some View {
        LazyVGrid(columns: appIconColumns) {
            ForEach(AppIcon.allCases, id: \.self) { appIcon in
                Image(uiImage: UIImage(named: appIcon.rawValue) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Layout.size(7.5), height: Layout.size(7.5))
                    .clipShape(RoundedRectangle(cornerRadius: Layout.size(1.5)))
                    .shadow(radius: Layout.size(0.5))
                    .overlay {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(SplytColor.white), Color(SplytColor.green))
                            .isVisible(viewModel.appIcon == appIcon)
                    }
                    .onTapGesture {
                        Task {
                            await viewModel.updateAppIcon(to: appIcon)
                        }
                    }
            }
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let colorTheme = "Color Theme"
    static let appIcon = "App Icon"
}
