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
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(SplytColor.allCases, id: \.self) { color in
                        Text(color.rawValue)
                            .footnote()
                            .frame(width: proxy.size.width / 2.2, height: Layout.size(6))
                            .roundedBackground(cornerRadius: Layout.size(0.5),
                                               fill: Color(splytColor: color))
                            .onTapGesture {
                                userTheme = color
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
