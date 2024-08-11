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
    private let accentColorColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    private let appIconColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        Form {
            appearanceMode
            section(title: Strings.accentColor) {
                accentColors
            }
            section(title: Strings.appIcon) {
                appIcons
            }
        }
    }
    
    private func section(title: String, 
                         content: @escaping () -> some View) -> some View {
        Section {
            content()
        } header: {
            Text(title)
                .subhead()
        }
    }
    
    private var appearanceMode: some View {
        Picker(Strings.appearance, selection: appearanceModeBinding) {
            ForEach(AppearanceMode.allCases, id: \.rawValue) { mode in
                HStack {
                    Image(systemName: mode.imageName)
                    Text(mode.title)
                }.tag(mode)
            }
        }
    }
    
    private var appearanceModeBinding: Binding<AppearanceMode> {
        return Binding(
            get: { return viewModel.appearanceMode },
            set: { viewModel.updateAppearanceMode(to: $0) }
        )
    }
    
    private var accentColors: some View {
        LazyVGrid(columns: accentColorColumns) {
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
    
    private var appIcons: some View {
        LazyVGrid(columns: appIconColumns) {
            ForEach(AppIcon.allCases, id: \.self) { appIcon in
                Image(uiImage: UIImage(named: appIcon.rawValue) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Layout.size(7.5), height: Layout.size(7.5))
                    .clipShape(RoundedRectangle(cornerRadius: Layout.size(1.5)))
                    .shadow(color: Color(SplytColor.shadow),
                            radius: Layout.size(0.5))
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
    static let appearance = "Appearance"
    static let accentColor = "Accent Color"
    static let appIcon = "App Icon"
}
