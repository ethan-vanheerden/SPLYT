import XCTest
@testable import ExerciseCore

final class SetInputTests: XCTestCase {
    private let repsWeight: SetInput = .repsWeight(reps: 8, weight: 135)
    private let repsOnly: SetInput = .repsOnly(reps: 5)
    private let time: SetInput = .time(seconds: 30)
    
    func testUpdateSetInput_RepsWeight() {
        let old = SetInput.repsWeight(reps: 5, weight: nil)
        
        XCTAssertEqual(old.updateSetInput(with: repsWeight), repsWeight)
        XCTAssertEqual(old.updateSetInput(with: repsOnly), old)
        XCTAssertEqual(old.updateSetInput(with: time), old)
    }
    
    func testUpdateSetInput_RepsOnly() {
        let old = SetInput.repsOnly(reps: nil)
        
        XCTAssertEqual(old.updateSetInput(with: repsWeight), old)
        XCTAssertEqual(old.updateSetInput(with: repsOnly), repsOnly)
        XCTAssertEqual(old.updateSetInput(with: time), old)
    }
    
    func testUpdateSetInput_Time() {
        let old = SetInput.time(seconds: 60)
        
        XCTAssertEqual(old.updateSetInput(with: repsWeight), old)
        XCTAssertEqual(old.updateSetInput(with: repsOnly), old)
        XCTAssertEqual(old.updateSetInput(with: time), time)
    }
}
