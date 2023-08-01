//
//  SettingsViewFactory.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import SwiftUI
import DesignShowcase

struct SettingsViewFactory {
    
    @ViewBuilder
    func makeView(_ item: SettingsItem) -> some View {
        switch item {
        case .designShowcase:
            DesignShowcaseProvider.designShowcaseView()
        case .restPresets:
            Text("rest presets")
        }
    }
}
