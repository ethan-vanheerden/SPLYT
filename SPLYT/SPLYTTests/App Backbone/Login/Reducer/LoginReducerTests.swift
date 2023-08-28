//
//  LoginReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT

final class LoginReducerTests: XCTestCase {
    typealias Fixtures = LoginFixtures
    private var mockService: MockLoginService!
    private var interactor: LoginInteractor!
    private var sut: LoginReducer!
    
    override func setUpWithError() throws {
        self.mockService = MockLoginService()
        self.interactor = LoginInteractor(service: mockService)
        self.sut = LoginReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded_StartingScreen() async {
        let domain = await load()
        let result = sut.reduce(domain)
        
        let expectedDisplay = Fixtures.display
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_EntryError() async {
        await load()
        let invalidEmail = "bad@email"
        let invalidPassword = "bad"
        _ = await interactor.interact(with: .updateEmail(newEmail: invalidEmail))
        let domain = await interactor.interact(with: .updatePassword(newPassword: invalidPassword))
        let result = sut.reduce(domain)
        
        let expectedDisplay = LoginDisplay(email: invalidEmail,
                                           password: invalidPassword,
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.invalidEmail,
                                           emailMessageColor: .red,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.invalidPassword,
                                           passwordMessageColor: .red,
                                           isCreateAccount: false,
                                           errorMessage: nil,
                                           submitButtonEnabled: false)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_ServiceError() async {
        mockService.createUserSuccess = false
        await loadAndFill()
        _ = await interactor.interact(with: .toggleCreateAccount(isCreateAccount: true))
        let domain = await interactor.interact(with: .submit)
        let result = sut.reduce(domain)
        
        let expectedDisplay = LoginDisplay(email: Fixtures.email,
                                           password: Fixtures.password,
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.validEmailMessage,
                                           emailMessageColor: .gray,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.validPasswordMessage,
                                           passwordMessageColor: .gray,
                                           isCreateAccount: true,
                                           errorMessage: Fixtures.errorOther,
                                           submitButtonEnabled: true)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_Filled() async {
        let domain = await loadAndFill()
        let result = sut.reduce(domain)
        
        let expectedDisplay = Fixtures.displayFilled
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
}

// MARK: - Private

private extension LoginReducerTests {
    @discardableResult
    func load() async -> LoginDomainResult {
        return await interactor.interact(with: .load)
    }
    
    @discardableResult
    func loadAndFill() async -> LoginDomainResult {
        await load()
        _ = await interactor.interact(with: .updateEmail(newEmail: Fixtures.email))
        return await interactor.interact(with: .updatePassword(newPassword: Fixtures.password))
    }
}
