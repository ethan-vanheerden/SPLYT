//
//  AboutView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/7/24.
//

import SwiftUI
import DesignSystem

struct AboutView: View {
    
    var body: some View {
        List {
            ForEach(Policy.allCases, id: \.self) { policy in
                SettingsListItem(viewState: .init(title: policy.title,
                                                  iconName: "link",
                                                  iconBackgroundColor: .gray,
                                                  link: policy.url))
            }
            NavigationLink {
                LicenseView(viewModel: LicenseViewModel(interactor: .init()))
                    .navigationBar(viewState: .init(title: Strings.licenses))
            } label: {
                SettingsListItem(viewState: .init(title: Strings.licenses,
                                                  iconName: "doc.fill",
                                                  iconBackgroundColor: .gray))
            }
        }
    }
}

fileprivate struct Strings {
    static let licenses = "Open Source Licenses"
}
