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
    case updateField(field: LoginField)
    case submit
    case fieldChangedFocus(field: LoginField, isFocused: Bool)
}

// MARK: - Domain Results

enum LoginDomainResult: Equatable {
    case error
    case loaded(LoginDomain)
}

// MARK: - Interactor

final class LoginInteractor {
    private let service: LoginServiceType
    private let startingValidBirthdate: Date
    private var savedDomain: LoginDomain?
    
    init(service: LoginServiceType = LoginService(),
         startingValidBirthdate: Date? = nil) {
        self.service = service
        
        if let startingValidBirthdate = startingValidBirthdate {
            self.startingValidBirthdate = startingValidBirthdate
        } else {
            self.startingValidBirthdate = Calendar.current.date(byAdding: .year,
                                                                value: -16,
                                                                to: Date.now) ?? Date.now
        }
    }
    
    func interact(with action: LoginDomainAction) async -> LoginDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .toggleCreateAccount(let isCreateAccount):
            return handleToggleCreateAccount(isCreateAccount: isCreateAccount)
        case .updateField(let field):
            return handleUpdateField(field: field)
        case .submit:
            return await handleSubmit()
        case let .fieldChangedFocus(field, isFocused):
            return handleFieldChangedFocus(field: field, isFocused: isFocused)
        }
    }
}

// MARK: - Private Handlers

private extension LoginInteractor {
    func handleLoad() -> LoginDomainResult {
        guard let termsURL = Policy.termsConditions.url else { return .error }
        
        let domain = LoginDomain(email: "",
                                 password: "",
                                 birthday: startingValidBirthdate,
                                 emailMessage: Strings.validEmailMessage,
                                 emailError: false,
                                 passwordMessage: Strings.validPasswordMessage,
                                 passwordError: false,
                                 birthdayMessage: Strings.birthdayMessage,
                                 birthdayError: false,
                                 isCreateAccount: false,
                                 errorMessage: nil,
                                 canSubmit: false,
                                 termsURL: termsURL)
        
        return updateDomain(domain: domain)
    }
    
    func handleToggleCreateAccount(isCreateAccount: Bool) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.isCreateAccount = isCreateAccount
        domain.errorMessage = nil // Reset the error message if there was one
        return updateDomain(domain: domain)
    }
    
    func handleUpdateField(field: LoginField) -> LoginDomainResult {
        switch field {
        case .email(let newEmail):
            return handleUpdateEmail(newEmail: newEmail)
        case .password(let newPassword):
            return handleUpdatePassword(newPassword: newPassword)
        case .birthday(let newBirthday):
            return handleUpdateBirthday(newBirthday: newBirthday)
        }
    }
    
    func handleSubmit() async -> LoginDomainResult {
        guard var domain = savedDomain,
              domain.canSubmit else { return .error }
        
        let email = domain.email
        let password = domain.password
        let success: Bool
        
        if domain.isCreateAccount {
            success = await service.createUser(email: email, password: password)
        } else {
            success = await service.login(email: email, password: password)
        }
        
        if success {
            domain.errorMessage = nil
        } else if domain.isCreateAccount {
            domain.errorMessage = Strings.errorOther
        } else {
            domain.errorMessage = Strings.errorCreateAccount
        }
        
        return updateDomain(domain: domain)
    }
    
    func handleFieldChangedFocus(field: LoginField, isFocused: Bool) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        switch field {
        case .email:
            let email = domain.email
            let emailValid = isEmailValid(email: email)
            domain.emailMessage = isFocused || emailValid || email.isEmpty ? Strings.validEmailMessage : Strings.invalidEmail
            domain.emailError = !isFocused && !emailValid && !email.isEmpty
            
            return updateDomain(domain: domain)
        case .password:
            let password = domain.password
            let passwordValid = isPasswordValid(password: password)
            domain.passwordMessage = isFocused || passwordValid || password.isEmpty ? Strings.validPasswordMessage : Strings.invalidPassword
            domain.passwordError = !isFocused && !passwordValid && !password.isEmpty
            
            return updateDomain(domain: domain)
        default:
            return updateDomain(domain: domain)
        }
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
    
    func handleUpdateEmail(newEmail: String) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.email = newEmail
        domain.canSubmit = canSubmit(email: domain.email,
                                     password: domain.password,
                                     birthday: domain.birthday,
                                     isCreateAccount: domain.isCreateAccount)
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdatePassword(newPassword: String) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        domain.password = newPassword
        domain.canSubmit = canSubmit(email: domain.email,
                                     password: domain.password,
                                     birthday: domain.birthday,
                                     isCreateAccount: domain.isCreateAccount)
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdateBirthday(newBirthday: Date) -> LoginDomainResult {
        guard var domain = savedDomain else { return .error }
        
        let birthdayValid = isBirthdayValid(birthday: newBirthday)
        domain.birthday = newBirthday
        domain.birthdayError = !birthdayValid
        domain.canSubmit = canSubmit(email: domain.email,
                                     password: domain.password,
                                     birthday: domain.birthday,
                                     isCreateAccount: domain.isCreateAccount)
        
        return updateDomain(domain: domain)
    }
    
    func isEmailValid(email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.matches(emailRegex)
    }
    
    func isPasswordValid(password: String) -> Bool {
        // Just checking the length for now
        return password.count >= 8
    }
    
    func isBirthdayValid(birthday: Date) -> Bool {
        // Users need to be at least 16 years old
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date.now)
        
        if let yearsOld = ageComponents.year {
            return yearsOld >= 16
        } else {
            return false
        }
    }
    
    func canSubmit(email: String,
                   password: String,
                   birthday: Date,
                   isCreateAccount: Bool) -> Bool {
        return isEmailValid(email: email)
        && isPasswordValid(password: password)
        && (isBirthdayValid(birthday: birthday) || !isCreateAccount)
    }
}


// MARK: - Strings

fileprivate struct Strings {
    static let validEmailMessage = "Must be a valid email"
    static let validPasswordMessage = "Password must be at least 8 characters"
    static let birthdayMessage = "You must be at least 16 years old to use SPLYT"
    static let invalidEmail = "Invalid email"
    static let invalidPassword = "Invalid password"
    static let errorCreateAccount = """
Something went wrong. Double check your password or create an account if you don't have one.
"""
    static let errorOther = "Something went wrong. Please try again later."
}
