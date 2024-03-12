//
//  RestPresetsView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import SwiftUI
import Core
import DesignSystem

struct RestPresetsView<VM: ViewModel>: View where VM.Event == RestPresetsViewEvent,
                                                  VM.ViewState == RestPresetsViewState {
    @ObservedObject private var viewModel: VM
    @Environment(\.dismiss) private var dismiss
    @State private var showRestPicker: Bool = false
    @State private var editPresetIndex: Int = 0 // Keeps track of the preset we are currently updating
    @State private var pickerMinutes: Int = 0
    @State private var pickerSeconds: Int = 0
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) },
                      backAction: { dismiss() })
        case .loaded(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: RestPresetsDisplay) -> some View {
        List {
            Section {
                ForEach(presetsBinding(presets: display.presets), id: \.self, editActions: .move) { $preset in
                    presetRow(preset: preset)
                }
            } footer: {
                Text(display.footerMessage)
                    .footnote()
            }
        }
        .sheet(isPresented: $showRestPicker) {
            restPicker
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
    
    private func presetsBinding(presets: [PresetDisplay]) -> Binding<[PresetDisplay]> {
        return Binding(
            get: { return presets },
            set: { newPresets in
                let presets = newPresets.map { $0.preset }
                viewModel.send(.updatePresets(newPresets: presets), taskPriority: .userInitiated)
                
            }
        )
    }
    
    @ViewBuilder
    private func presetRow(preset: PresetDisplay) -> some View {
        HStack {
            Text(preset.title)
                .subhead(style: .semiBold)
                .onTapGesture {
                    editPresetIndex = preset.index // Stores this info for the sheet
                    pickerMinutes = preset.minutes
                    pickerSeconds = preset.seconds
                    showRestPicker = true
                }
            Spacer()
            Image(systemName: "line.3.horizontal")
                .foregroundColor(Color(splytColor: .gray))
        }
    }
    
    @ViewBuilder
    private var restPicker: some View {
        RestPicker(minutes: $pickerMinutes,
                   seconds: $pickerSeconds,
                   confirmAction: {
            showRestPicker = false
            viewModel.send(.updatePreset(index: editPresetIndex, minutes: pickerMinutes, seconds: pickerSeconds))
        },
                   cancelAction: {
            pickerMinutes = 0
            pickerSeconds = 0
            showRestPicker = false
        })
    }
}
