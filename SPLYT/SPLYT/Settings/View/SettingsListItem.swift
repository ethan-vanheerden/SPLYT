//
//  SettingsListItem.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/7/24.
//

import SwiftUI
import DesignSystem

struct SettingsListItem: View {
    private let title: String
    private let iconName: String
    private let iconBackgroundColor: SplytColor
    
    init(title: String,
         iconName: String,
         iconBackgroundColor: SplytColor) {
        self.title = title
        self.iconName = iconName
        self.iconBackgroundColor = iconBackgroundColor
    }
    
    var body: some View {
        HStack {
            IconImage(imageName: iconName,
                      backgroundColor: iconBackgroundColor)
            Text(title)
                .subhead(style: .semiBold)
                .foregroundColor(Color(splytColor: .black))
            Spacer()
        }
    }
}
