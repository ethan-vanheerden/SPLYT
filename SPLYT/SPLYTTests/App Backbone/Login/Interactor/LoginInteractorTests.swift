//
//  LoginInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class LoginInteractorTests: XCTestCase {
    typealias Fixtures = LoginFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockLoginService!
    private var sut: LoginInteractor!
    
    override func setUpWithError() throws {
        self.mockService = MockLoginService()
        self.sut = LoginInteractor(service: mockService,
                                   startingValidBirthdate: WorkoutFixtures.oct_16_2000_0000)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = Fixtures.domain
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleCreateAccount_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleCreateAccount(isCreateAccount: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleCreateAccount_Success() async {
        await load()
        var result = await sut.interact(with: .toggleCreateAccount(isCreateAccount: true))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.isCreateAccount = true
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        
        result = await sut.interact(with: .toggleCreateAccount(isCreateAccount: false))
        
        expectedDomain.isCreateAccount = false
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateEmail_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateEmail(newEmail: Fixtures.email))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateEmail_EmptyEmail_Success() async {
        await load()
        let result = await sut.interact(with: .updateEmail(newEmail: ""))
        
        let expectedDomain = Fixtures.domain
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateEmail_InvalidEmail_Success() async {
        await load()
        let invalidEmail = "@abcdefg"
        let result = await sut.interact(with: .updateEmail(newEmail: invalidEmail))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.email = invalidEmail
        expectedDomain.emailError = true
        expectedDomain.emailMessage = Fixtures.invalidEmail
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateEmail_ValidEmail_Success() async {
        await load()
        let result = await sut.interact(with: .updateEmail(newEmail: Fixtures.email))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.email = Fixtures.email
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdatePassword_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updatePassword(newPassword: Fixtures.password))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdatePassword_EmptyPassword_Success() async {
        await load()
        let result = await sut.interact(with: .updatePassword(newPassword: ""))
        
        let expectedDomain = Fixtures.domain
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdatePassword_InvalidPassword_Success() async {
        await load()
        let invalidPassword = "short"
        let result = await sut.interact(with: .updatePassword(newPassword: invalidPassword))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.password = invalidPassword
        expectedDomain.passwordError = true
        expectedDomain.passwordMessage = Fixtures.invalidPassword
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdatePassword_ValidPassword_Success() async {
        await load()
        let result = await sut.interact(with: .updatePassword(newPassword: Fixtures.password))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.password = Fixtures.password
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateBirthday_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateBirthday(newBirthday: WorkoutFixtures.mar_8_2002_1200))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateBirthday_InvalidDate_Success() async throws {
        await load()
        let invalidDate = try XCTUnwrap(Calendar.current.date(byAdding: .year,
                                                              value: -15,
                                                              to: Date.now))
        _ = await sut.interact(with: .toggleCreateAccount(isCreateAccount: true))
        let result = await sut.interact(with: .updateBirthday(newBirthday: invalidDate))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.birthday = invalidDate
        expectedDomain.birthdayError = true
        expectedDomain.isCreateAccount = true
        expectedDomain.canSubmit = false
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateBirthday_InvalidDate_IsCreateAccount_Success() async throws {
        await loadAndFill()
        let invalidDate = try XCTUnwrap(Calendar.current.date(byAdding: .year,
                                                              value: -15,
                                                              to: Date.now))
        _ = await sut.interact(with: .toggleCreateAccount(isCreateAccount: false))
        let result = await sut.interact(with: .updateBirthday(newBirthday: invalidDate))
        
        var expectedDomain = Fixtures.domainFilled
        expectedDomain.birthday = invalidDate
        expectedDomain.birthdayError = true
        expectedDomain.isCreateAccount = false
        expectedDomain.canSubmit = true
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateBirthday_ValidDate_Success() async {
        await load()
        let result = await sut.interact(with: .updateBirthday(newBirthday: WorkoutFixtures.mar_8_2002_1200))
        
        var expectedDomain = Fixtures.domain
        expectedDomain.birthday = WorkoutFixtures.mar_8_2002_1200
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateFields_Success() async {
        await load()
        _ = await sut.interact(with: .updateEmail(newEmail: Fixtures.email))
        _ = await sut.interact(with: .updatePassword(newPassword: Fixtures.password))
        let result = await sut.interact(with: .updateBirthday(newBirthday: WorkoutFixtures.mar_8_2002_1200))
        
        let expectedDomain = Fixtures.domainFilled
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Submit_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .submit)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Submit_CantSubmit_Error() async {
        await load()
        let result = await sut.interact(with: .submit)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Submit_Login_ServiceError() async {
        mockService.loginSuccess = false
        await loadAndFill()
        let result = await sut.interact(with: .submit)
        
        var expectedDomain = Fixtures.domainFilled
        expectedDomain.errorMessage = Fixtures.errorCreateAccount
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Submit_CreateAccount_ServiceError() async {
        mockService.createUserSuccess = false
        await loadAndFill()
        _ = await sut.interact(with: .toggleCreateAccount(isCreateAccount: true))
        let result = await sut.interact(with: .submit)
        
        var expectedDomain = Fixtures.domainFilled
        expectedDomain.isCreateAccount = true
        expectedDomain.errorMessage = Fixtures.errorOther
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Submit_Login_Success() async {
        await loadAndFill()
        let result = await sut.interact(with: .submit)
        
        let expectedDomain = Fixtures.domainFilled
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Submit_CreateAccount_Success() async {
        await loadAndFill()
        _ = await sut.interact(with: .toggleCreateAccount(isCreateAccount: true))
        let result = await sut.interact(with: .submit)
        
        var expectedDomain = Fixtures.domainFilled
        expectedDomain.isCreateAccount = true
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
}

// MARK: - Private

private extension LoginInteractorTests {
    func load() async {
        _ = await sut.interact(with: .load)
    }
    
    func loadAndFill() async {
        await load()
        _ = await sut.interact(with: .updateEmail(newEmail: Fixtures.email))
        _ = await sut.interact(with: .updatePassword(newPassword: Fixtures.password))
        _ = await sut.interact(with: .updateBirthday(newBirthday: WorkoutFixtures.mar_8_2002_1200))
    }
}
