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
                if let url = policy.url {
                    Link(destination: url) {
                        SettingsListItem(title: policy.title,
                                         iconName: "link",
                                         iconBackgroundColor: .gray)
                    }
                }
            }
            NavigationLink {
                LicensesView()
                    .navigationBar(viewState: .init(title: Strings.licenses))
            } label: {
                SettingsListItem(title: Strings.licenses,
                                 iconName: "doc.fill",
                                 iconBackgroundColor: .lightBlue)
            }
        }
    }
}

fileprivate struct Strings {
    static let licenses = "Open Source Licenses"
}
