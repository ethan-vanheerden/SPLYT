import XCTest
@testable import Networking

final class ServerURLTests: XCTestCase {
    func testCreateURL() throws {
        let subPath = "/test/url"
        let actual = ServerURL.createURL(path: subPath)
        let expected = try XCTUnwrap(URL(string:"http://splyt-dev.us-east-1.elasticbeanstalk.com/test/url"))
        XCTAssertEqual(actual, expected)
    }
}
