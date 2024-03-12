//
//  LoginReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class LoginReducerTests: XCTestCase {
    typealias Fixtures = LoginFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockLoginService!
    private var interactor: LoginInteractor!
    private var sut: LoginReducer!
    
    override func setUpWithError() throws {
        self.mockService = MockLoginService()
        self.interactor = LoginInteractor(service: mockService,
                                          startingValidBirthdate: WorkoutFixtures.oct_16_2000_0000)
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
        let invalidBirthday = Date.now
        _ = await interactor.interact(with: .updateEmail(newEmail: invalidEmail))
        _ = await interactor.interact(with: .updatePassword(newPassword: invalidPassword))
        let domain = await interactor.interact(with: .updateBirthday(newBirthday: invalidBirthday))
        let result = sut.reduce(domain)
        
        let expectedDisplay = LoginDisplay(email: invalidEmail,
                                           password: invalidPassword,
                                           birthday: invalidBirthday,
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.invalidEmail,
                                           emailMessageColor: .red,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.invalidPassword,
                                           passwordMessageColor: .red,
                                           birthdayMessage: Fixtures.birthdayMessage,
                                           birthdayMessageColor: .red,
                                           isCreateAccount: false,
                                           errorMessage: nil,
                                           submitButtonEnabled: false,
                                           createAccountNavBar: Fixtures.createAccountNavBar,
                                           termsURL: Fixtures.termsURL)
        
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
                                           birthday: WorkoutFixtures.mar_8_2002_1200,
                                           emailTextEntry: Fixtures.emailTextEntry,
                                           emailMessage: Fixtures.validEmailMessage,
                                           emailMessageColor: .gray,
                                           passwordTextEntry: Fixtures.passwordTextEntry,
                                           passwordMessage: Fixtures.validPasswordMessage,
                                           passwordMessageColor: .gray,
                                           birthdayMessage: Fixtures.birthdayMessage,
                                           birthdayMessageColor: .gray,
                                           isCreateAccount: true,
                                           errorMessage: Fixtures.errorOther,
                                           submitButtonEnabled: true,
                                           createAccountNavBar: Fixtures.createAccountNavBar,
                                           termsURL: Fixtures.termsURL)
        
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
        _ = await interactor.interact(with: .updatePassword(newPassword: Fixtures.password))
        return await interactor.interact(with: .updateBirthday(newBirthday: WorkoutFixtures.mar_8_2002_1200))
    }
}
