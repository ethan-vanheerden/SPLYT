import XCTest
@testable import ExerciseCore

final class SetInputTests: XCTestCase {
    private let repsWeight: SetInput = .repsWeight(input: .init(weight: 135, reps: 8))
    private let repsOnly: SetInput = .repsOnly(input: .init(reps: 5))
    private let time: SetInput = .time(input: .init(seconds: 30))
    
    func testUpdateSetInput_RepsWeight() {
        let old = SetInput.repsWeight(input: .init(weight: nil, reps: 5))
        
        XCTAssertEqual(old.updateSetInput(with: repsWeight), repsWeight)
        XCTAssertEqual(old.updateSetInput(with: repsOnly), old)
        XCTAssertEqual(old.updateSetInput(with: time), old)
    }
    
    func testUpdateSetInput_RepsOnly() {
        let old = SetInput.repsOnly(input: .init(reps: nil))
        
        XCTAssertEqual(old.updateSetInput(with: repsWeight), old)
        XCTAssertEqual(old.updateSetInput(with: repsOnly), repsOnly)
        XCTAssertEqual(old.updateSetInput(with: time), old)
    }
    
    func testUpdateSetInput_Time() {
        let old = SetInput.time(input: .init(seconds: 60))
        
        XCTAssertEqual(old.updateSetInput(with: repsWeight), old)
        XCTAssertEqual(old.updateSetInput(with: repsOnly), old)
        XCTAssertEqual(old.updateSetInput(with: time), time)
    }
}
