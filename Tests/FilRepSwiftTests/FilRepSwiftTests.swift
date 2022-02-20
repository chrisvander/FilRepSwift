import XCTest
@testable import FilRepSwift

final class FilRepSwiftTests: XCTestCase {
    var filrep = FilRepSwift()
    
    override func setUpWithError() throws {
        self.filrep = FilRepSwift()
    }
    
    @available(macOS 12.0, *)
    func testGetMinersWithLimit() async throws {
        let miners = try await filrep.getMiners(limit: 10)
        XCTAssert(miners[0].rank == "1")
        XCTAssert(miners.count == 10)
    }
    
    @available(macOS 12.0, *)
    func testGetMinerInRegion() async throws {
        let miners = try await filrep.getMiners(limit: 10, region: .NorthAmerica)
        XCTAssert(miners[0].region == .NorthAmerica)
    }
    
    @available(macOS 12.0, *)
    func testMinerOffset() async throws {
        let miners = try await filrep.getMiners(offset: 10, limit: 10, sortBy: .score)
        XCTAssert(miners[0].rank == "11")
        XCTAssert(miners[9].rank == "20")
    }
    
    func testCallbackUsage() {
        filrep.getMiners(limit: 10) { result in
            switch result {
            case .success(let miners):
                XCTAssert(!miners.isEmpty)
            case .failure(let error):
                XCTFail("failed: \(error)")
            }
        }
    }
}
