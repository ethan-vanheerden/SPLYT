//
//  LoginInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/19/23.
//

import Foundation

// MARK: - Domain Actions

enum LoginDomainAction {
    case load
    case toggleCreateAccount(isCreateAccount: Bool)
    case togglePasswordVisible(isVisible: Bool)
    case updateEmail(newEmail: String)
    case updatePassword(newPassword: String)
    case submit(isCreateAccout: Bool)
}

// MARK: - Domain Results

enum LoginDomainResult: Equatable {
    case error
    case loaded(LoginDomain)
    case loggedIn
}

// MARK: - Interactor

final class LoginInteractor {
    private let service: LoginServiceType
    private var savedDomain: LoginDomain?
    
    init(service: LoginServiceType = LoginService()) {
        self.service = service
    }
    
    func interact(with action: LoginDomainAction) async -> LoginDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .toggleCreateAccount(let isCreateAccount):
            return handleToggleCreateAccount(isCreateAccount: isCreateAccount)
        case .togglePasswordVisible(let isVisible):
            return handleTogglePasswordVisible(isVisible: isVisible)
        case .updateEmail(let newEmail):
            return handleUpdateEmail(newEmail: newEmail)
        case .updatePassword(let newPassword):
            return handleUpdatePassword(newPassword: newPassword)
        case .submit(let isCreateAccout):
            return await handleSubmit(isCreateAccout: isCreateAccout)
        }
    }
}

// MARK: - Private Handlers

private extension LoginInteractor {
    func handleLoad() -> LoginDomainResult {
        let domain = LoginDomain(email: "",
                                 password: "",
                                 emailMessage: nil,
                                 passwordMessage: Strings.passwordLengthMessage,
                                 passwordError: false,
                                 createAccount: false,
                                 passwordVisible: false,
                                 errorMessage: nil,
                                 canSubmit: false)
        
        return updateDomain(domain: domain)
    }
    
    func handleToggleCreateAccount(isCreateAccount: Bool) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.createAccount = isCreateAccount
        return updateDomain(domain: domain)
    }
    
    func handleTogglePasswordVisible(isVisible: Bool) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.passwordVisible = isVisible
        return updateDomain(domain: domain)
    }
    
    func handleUpdateEmail(newEmail: String) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        let emailValid = isEmailValid(email: newEmail)
        domain.email = newEmail
        domain.emailMessage = emailValid ? nil : Strings.invalidEmail
        domain.canSubmit = canSubmit(email: domain.email, password: domain.password)
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdatePassword(newPassword: String) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        let passwordValid = isPasswordValid(password: newPassword)
        domain.password = newPassword
        domain.passwordMessage = passwordValid ? Strings.passwordLengthMessage : Strings.invalidPassword
        domain.passwordError = !passwordValid
        domain.canSubmit = canSubmit(email: domain.email, password: domain.password)
        
        return updateDomain(domain: domain)
    }
    
    func handleSubmit(isCreateAccout: Bool) async -> LoginDomainResult {
        guard var domain = savedDomain,
              domain.canSubmit else { return .error }
        
        let email = domain.email
        let password = domain.password
        let success: Bool
        
        if isCreateAccout {
            success = await service.createUser(email: email, password: password)
        } else {
            success = await service.login(email: email, password: password)
        }
        
        if success {
            return .loggedIn
        } else if isCreateAccout {
            domain.errorMessage = Strings.errorCreateAccount
        } else {
            domain.errorMessage = Strings.errorOther
        }
        
        return updateDomain(domain: domain)
    }
}

// MARK: - Other Private Helpers

private extension LoginInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: LoginDomain) -> LoginDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
    
    func isEmailValid(email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.matches(emailRegex)
    }
    
    func isPasswordValid(password: String) -> Bool {
        // Just checking the length for now
        return password.count >= 8
    }
    
    func canSubmit(email: String, password: String) -> Bool {
        return isEmailValid(email: email) && isPasswordValid(password: password)
    }
}


// MARK: - Strings

fileprivate struct Strings {
    static let passwordLengthMessage = "Password must be at least 8 characters"
    static let invalidEmail = "Invalid email"
    static let invalidPassword = "Invalid password"
    static let errorCreateAccount = "Something went wrong. If you don't yet have an account, create one below."
    static let errorOther = "Something went wrong. Please try again later."
}
