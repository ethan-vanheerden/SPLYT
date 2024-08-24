//
//  ThemedControllers.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/24/24.
//

import UIKit
import SwiftUI
import DesignSystem
import Core

// MARK: - UINavigationController

/// Custom controller used to propagte the user's desired appearance mode to  UINavigationControllers.
final class ThemedNavigationController: UINavigationController {
    var preferredColorScheme: AppearanceMode = AppearanceTheme.shared.mode {
        didSet {
            overrideUserInterfaceStyle = preferredColorScheme.uiUserInterfaceStyle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = preferredColorScheme.uiUserInterfaceStyle
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        overrideUserInterfaceStyle = preferredColorScheme.uiUserInterfaceStyle
    }
}

// MARK: - UIHostingController

/// Custom controller used to propagte the user's desired appearnce mode to UIHostingControllers.
final class ThemedHostingController<Content: View>: UIHostingController<Content> {
    var preferredColorScheme: AppearanceMode = AppearanceTheme.shared.mode {
        didSet {
            overrideUserInterfaceStyle = preferredColorScheme.uiUserInterfaceStyle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the initial color scheme
        overrideUserInterfaceStyle = preferredColorScheme.uiUserInterfaceStyle
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Ensure the preferred color scheme is applied when the trait collection changes
        overrideUserInterfaceStyle = preferredColorScheme.uiUserInterfaceStyle
    }
}
