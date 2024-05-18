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
    @State private var date = Date.now
    @EnvironmentObject private var userTheme: UserTheme
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
            ErrorView(retryAction: { viewModel.send(.load, taskPriority: .userInitiated) })
        case .loaded(let display):
            mainView(display: display)
        }
    }
    
    @ViewBuilder
    private func mainView(display: LoginDisplay) -> some View {
        VStack {
            Text(Strings.SPLYT)
                .largeTitle()
                .foregroundStyle(SplytGradient.classic.gradient())
                .padding(.top, Layout.size(4))
            Spacer()
            Text(Strings.welcomeBack)
                .title1()
                .foregroundStyle(SplytGradient.classic.gradient())
                .padding(.bottom, Layout.size(2))
            textEntries(display: display, createAccount: false)
            submitButton(isCreateAccount: false,
                         isEnabled: display.submitButtonEnabled,
                         errorMessage: display.errorMessage)
            HStack {
                Text(Strings.dontHaveAccount)
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
            if createAccount {
                birthdayPicker(birthday: display.birthday)
                Text(display.birthdayMessage)
                    .footnote()
                    .foregroundColor(Color(splytColor: display.birthdayMessageColor))
            }
        }
        .padding(.bottom, Layout.size(4))
    }
    
    private func emailTextBinding(email: String) -> Binding<String> {
        return Binding(
            get: { return email },
            set: { viewModel.send(.updateEmail(newEmail: $0),
                                  taskPriority: .userInitiated) }
        )
    }
    
    private func passwordTextBinding(password: String) -> Binding<String> {
        return Binding(
            get: { return password },
            set: { viewModel.send(.updatePassword(newPassword: $0),
                                  taskPriority: .userInitiated) }
        )
    }
    
    private func birthdayBinding(birthday: Date) -> Binding<Date> {
        return Binding(
            get: { return birthday },
            set: { viewModel.send(.updateBirthday(newBirthday: $0),
                                  taskPriority: .userInitiated) }
        )
    }
    
    @ViewBuilder
    private func birthdayPicker(birthday: Date) -> some View {
        VStack {
            DatePicker(selection: birthdayBinding(birthday: birthday),
                       in: ...Date.now, displayedComponents: .date) {
                Text(Strings.birthday)
                    .body()
            }
                       .tint(Color(splytColor: userTheme.theme))
        }
        .padding(.top, Layout.size(1))
    }
    
    @ViewBuilder
    private func submitButton(isCreateAccount: Bool, isEnabled: Bool, errorMessage: String?) -> some View {
        let buttonText = isCreateAccount ? Strings.createAccount : Strings.login
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
                Text(Strings.welcome)
                    .title1()
                    .foregroundStyle(SplytGradient.classic.gradient())
                Spacer()
            }
            .padding(.bottom, Layout.size(1))
            textEntries(display: display, createAccount: true)
            Spacer()
            termsLink(termsURL: display.termsURL)
            submitButton(isCreateAccount: true,
                         isEnabled: display.submitButtonEnabled,
                         errorMessage: display.errorMessage)
        }
        .padding(.top, Layout.size(2))
        .padding(.horizontal, Layout.size(2))
        .navigationBar(viewState: display.createAccountNavBar,
                       backAction: { viewModel.send(.toggleCreateAccount(isCreateAccount: false),
                                                    taskPriority: .userInitiated) })
    }
    
    @ViewBuilder private func termsLink(termsURL: URL) -> some View {
        VStack {
            Text(Strings.bySigningUp)
                .footnote()
                .foregroundColor(Color(splytColor: .gray))
            Link(destination: termsURL) {
                Text(Strings.termsConditions)
                    .footnote()
                    .foregroundColor(Color(splytColor: userTheme.theme))
            }
        }
    }
}

fileprivate struct Strings {
    static let SPLYT = "SPLYT"
    static let welcomeBack = "Welcome back!"
    static let dontHaveAccount = "Don't have an account yet? Create one!"
    static let login = "Login"
    static let createAccount = "Create Account"
    static let welcome = "Welcome!"
    static let birthday = "Birthday"
    static let bySigningUp = "By signing up, you agree to the"
    static let termsConditions = "Terms and Conditions"
}
