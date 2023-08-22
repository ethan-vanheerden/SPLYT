//
//  LoginView.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation
import SwiftUI
import Core
import DesignSystem

struct LoginView<VM: ViewModel>: View where VM.Event == LoginViewEvent,
                                            VM.ViewState == LoginViewState {
    @ObservedObject private var viewModel: VM
    private let navigationRouter: LoginNavigationRouter
    private let horizontalPadding = Layout.size(2)
    
    init(viewModel: VM,
         navigationRouter: LoginNavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
        self.viewModel.send(.load, taskPriority: .userInitiated)
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .error:
            Text("Error!")
        case .loaded(let display):
            mainView(display: display)
        case .loggedIn:
            Text("Logged in!")
        }
    }
    
    @ViewBuilder
    private func mainView(display: LoginDisplay) -> some View {
        VStack {
            Text("SPLYT")
                .largeTitle()
                .foregroundStyle(LinearGradient(colors: [Color(splytColor: .lightBlue), Color(splytColor: .purple)], startPoint: .bottomLeading, endPoint: .topTrailing))
                .padding(.top, Layout.size(4))
            Spacer()
            Text("Welcome back!")
                .title1()
                .foregroundStyle(LinearGradient(colors: [Color(splytColor: .lightBlue), Color(splytColor: .purple)], startPoint: .bottomLeading, endPoint: .topTrailing))
                .padding(.bottom, Layout.size(2))
            textEntries(display: display, createAccount: false)
            submitButton(isCreateAccount: false,
                         isEnabled: display.submitButtonEnabled,
                         errorMessage: display.errorMessage)
            HStack {
                Text("Don't have an account yet? Create one!")
                    .footnote()
                    .foregroundColor(Color(splytColor: .gray))
                Spacer()
            }
            .onTapGesture {
                viewModel.send(.toggleCreateAccount(isCreateAccount: true), taskPriority: .userInitiated)
            }
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
        .fullScreenCover(isPresented: .constant(display.isCreateAccount)) {
            createAccountView(display: display)
        }
    }
    
    @ViewBuilder
    private func textEntries(display: LoginDisplay, createAccount: Bool) -> some View {
        VStack(alignment: .leading) {
            TextEntry(text: emailTextBinding(email: display.email),
                      viewState: display.emailTextEntry)
            if createAccount {
                Text(display.emailMessage)
                    .footnote()
                    .foregroundColor(Color(splytColor: display.emailMessageColor))
                    .padding(.bottom, Layout.size(1))
            }
            TextEntry(text: passwordTextBinding(password: display.password),
                      viewState: display.passwordTextEntry)
            if createAccount {
                Text(display.passwordMessage)
                    .footnote()
                    .foregroundColor(Color(splytColor: display.passwordMessageColor))
            }
        }
        .padding(.bottom, Layout.size(4))
    }
    
    private func emailTextBinding(email: String) -> Binding<String> {
        return Binding(
            get: { return email },
            set: { viewModel.send(.updateEmail(newEmail: $0), taskPriority: .userInitiated)}
        )
    }
    
    private func passwordTextBinding(password: String) -> Binding<String> {
        return Binding(
            get: { return password },
            set: { viewModel.send(.updatePassword(newPassword: $0), taskPriority: .userInitiated)}
        )
    }
    
    @ViewBuilder
    private func submitButton(isCreateAccount: Bool, isEnabled: Bool, errorMessage: String?) -> some View {
        let buttonText = isCreateAccount ? "Create Account" : "Login"
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .footnote()
                    .foregroundColor(Color(splytColor: .red))
            }
            SplytButton(text: buttonText,
                        isEnabled: isEnabled) {
                viewModel.send(.submit, taskPriority: .userInitiated)
            }
        }
    }
    
    @ViewBuilder
    private func createAccountView(display: LoginDisplay) -> some View {
        VStack {
            HStack {
                Text("Welcome!")
                    .title1()
                    .foregroundStyle(LinearGradient(colors: [Color(splytColor: .lightBlue), Color(splytColor: .purple)], startPoint: .bottomLeading, endPoint: .topTrailing))
                Spacer()
            }
            .padding(.bottom, Layout.size(1))
            textEntries(display: display, createAccount: true)
            Spacer()
            submitButton(isCreateAccount: true,
                         isEnabled: display.submitButtonEnabled,
                         errorMessage: display.errorMessage)
        }
        .padding(.top, Layout.size(2))
        .padding(.horizontal, Layout.size(2))
        .navigationBar(viewState: .init(title: "Create Account",
                                       backIconName: "xmark"),
                       backAction: { viewModel.send(.toggleCreateAccount(isCreateAccount: false),
                                                    taskPriority: .userInitiated) })
    }
}
