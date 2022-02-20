import XCTest
@testable import FilRepSwift

@available(macOS 12.0, *)
final class FilRepSwiftTests: XCTestCase {
    func testExample() async throws {
        let miners = try await FilRepSwift().getMiners(limit: 10)
        print(miners)
    }
}
