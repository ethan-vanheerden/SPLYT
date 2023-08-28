//
//  LoginViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT

final class LoginViewModelTests: XCTestCase {
    typealias Fixtures = LoginFixtures
    private var sut: LoginViewModel!

    override func setUpWithError() throws {
        let interactor = LoginInteractor(service: MockLoginService())
        self.sut = LoginViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Error() async {
        await sut.send(.submit) // No saved domain
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = Fixtures.display
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_ToggleCreateAccount() async {
        await load()
        await sut.send(.toggleCreateAccount(isCreateAccount: true))
        
        let expectedDisplay = LoginDisplay(email: "",
                                           password: "",
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.validEmailMessage,
                                           emailMessageColor: .gray,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.validPasswordMessage,
                                           passwordMessageColor: .gray,
                                           isCreateAccount: true,
                                           errorMessage: nil,
                                           submitButtonEnabled: false,
                                           createAccountNavBar: Fixtures.createAccountNavBar)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_UpdateEmail() async {
        await load()
        await sut.send(.updateEmail(newEmail: "abc"))
        
        let expectedDisplay = LoginDisplay(email: "abc",
                                           password: "",
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.invalidEmail,
                                           emailMessageColor: .red,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.validPasswordMessage,
                                           passwordMessageColor: .gray,
                                           isCreateAccount: false,
                                           errorMessage: nil,
                                           submitButtonEnabled: false,
                                           createAccountNavBar: Fixtures.createAccountNavBar)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_UpdatePassword() async {
        await load()
        await sut.send(.updatePassword(newPassword: "abc"))
        
        let expectedDisplay = LoginDisplay(email: "",
                                           password: "abc",
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.validEmailMessage,
                                           emailMessageColor: .gray,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.invalidPassword,
                                           passwordMessageColor: .red,
                                           isCreateAccount: false,
                                           errorMessage: nil,
                                           submitButtonEnabled: false,
                                           createAccountNavBar: Fixtures.createAccountNavBar)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_Submit() async {
        await load()
        await sut.send(.updateEmail(newEmail: Fixtures.email))
        await sut.send(.updatePassword(newPassword: Fixtures.password))
        await sut.send(.submit)
        
        let expectedDisplay = Fixtures.displayFilled
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}

// MARK: - Private

private extension LoginViewModelTests {
    func load() async {
        await sut.send(.load)
    }
}
