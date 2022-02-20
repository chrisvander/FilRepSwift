# FilRep API - Swift Wrapper

A lightweight Swift wrapper around the [filrep.io](https://filrep.io) API. You can fetch using callbacks or async/await (iOS 15/macOS 12.0):
```swift
import FilRepSwift

filrep = FilRepSwift()
let miners = try await filrep.getMiners()
// or
filrep.getMiners() { result in
    switch result {
    case .success(let miners):
        // use list of miners
    case .failure(let error):
        // handle error
    }
}
```

By default, getMiners will fetch with a limit of 10 and otherwise leave default parameters going to the API. All query parameters are implemented into the getMiners function, so you could request the first hundred from a Europe sorted by freeSpace by using:

```swift
let miners = try await filrep.getMiners(limit: 100, region: .Europe, sortBy: .freeSpace)
```

The `Miner` class exposes the following class with constants, parsed directly from the JSON response:
```swift
public class Miner: Codable {
    let id: Int
    let address: String
    let status: Bool
    let uptimeAverage: Float
    let price: String
    let rawPower: String
    let qualityAdjPower: String
    let isoCode: String
    let region: Region
    let freeSpace: String
    let storageDeals: MinerStorageDeals
    let scores: MinerScores
    
    let rank: String
    let regionRank: String
    
    public class MinerStorageDeals: Codable {
        let total: Int
        let noPenalties: Int
        let successRate: String
        let averagePrice: String
        let dataStored: String
        let slashed: Int
    }
    
    public class MinerScores: Codable {
        let total: String
        let uptime: String
        let storageDeals: String
        let committedSectorsProofs: String
    }
}
```
