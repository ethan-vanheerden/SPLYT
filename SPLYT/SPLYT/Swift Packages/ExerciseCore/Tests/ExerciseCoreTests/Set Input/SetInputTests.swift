import XCTest
@testable import ExerciseCore

final class SetInputTests: XCTestCase {
    
    func testPlaceholderInput_RepsWeight() {
        let inputOne: SetInput = .repsWeight(input: .init())
        let inputTwo: SetInput = .repsWeight(input: .init(weight: 135,
                                                          weightPlaceholder: 100,
                                                          reps: 8,
                                                          repsPlaceholder: 10))
        let expected: SetInput = .repsWeight(input: .init(weight: 100,
                                                          weightPlaceholder: 100,
                                                          reps: 10,
                                                          repsPlaceholder: 10))
        
        XCTAssertEqual(inputOne.placeholderInput, inputOne)
        XCTAssertEqual(inputTwo.placeholderInput, expected)
    }
    
    func testPlaceholderInput_RepsOnly() {
        let inputOne: SetInput = .repsOnly(input: .init())
        let inputTwo: SetInput = .repsOnly(input: .init(reps: 8,
                                                        placeholder: 10))
        let expected: SetInput = .repsOnly(input: .init(reps: 10,
                                                        placeholder: 10))
        
        XCTAssertEqual(inputOne.placeholderInput, inputOne)
        XCTAssertEqual(inputTwo.placeholderInput, expected)
    }
    
    func testPlaceholderInput_Time() {
        let inputOne: SetInput = .time(input: .init())
        let inputTwo: SetInput = .time(input: .init(seconds: 60,
                                                    placeholder: 30))
        let expected: SetInput = .time(input: .init(seconds: 30,
                                                    placeholder: 30))
        
        XCTAssertEqual(inputOne.placeholderInput, inputOne)
        XCTAssertEqual(inputTwo.placeholderInput, expected)
    }
}
