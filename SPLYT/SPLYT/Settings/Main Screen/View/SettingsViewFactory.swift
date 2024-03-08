//
//  SettingsViewFactory.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import SwiftUI
import DesignShowcase

struct SettingsViewFactory {
    
    /// Handles instantiating the views when a Settings item should navigate to a new screen.
    /// Note: Not needed for non-navigation items.
    @ViewBuilder
    func makeView(_ item: SettingsItem) -> some View {
        switch item {
        case .designShowcase:
            DesignShowcaseProvider.designShowcaseView()
        case .restPresets:
            let interactor = RestPresetsInteractor()
            let viewModel = RestPresetsViewModel(interactor: interactor)
            RestPresetsView(viewModel: viewModel)
        case .about:
            AboutView()
        default:
            EmptyView()
        }
    }
}
