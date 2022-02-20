import Foundation

@available(macOS 12.0, *)
public struct FilRepSwift {
    let apiUrl: String = "https://api.filrep.io/api/v1/miners"
    
    public func getMiners(
        offset: Int? = nil,
        limit: Int? = nil,
        sortBy: SortingOption? = nil,
        order: Order? = nil,
        search: String? = nil,
        region: Region? = nil
    ) async throws -> [Miner] {
        func createURLQuery(title: String, value o: CustomStringConvertible?) -> URLQueryItem? {
            (o != nil) ? URLQueryItem(name: title, value: String(describing: o!)) : nil
        }
        
        let queryParams: [URLQueryItem] = [
            createURLQuery(title: "offset", value: offset),
            createURLQuery(title: "limit", value: limit),
            createURLQuery(title: "sortBy", value: sortBy),
            createURLQuery(title: "order", value: order),
            createURLQuery(title: "search", value: search),
            createURLQuery(title: "region", value: region),
        ].compactMap { $0 }
        
        var urlComponents = URLComponents(string: apiUrl)!
        urlComponents.queryItems = queryParams
        let url = urlComponents.url!
        let (data, _) = try await URLSession.shared.data(from: url)
    
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let filRepResponse = try decoder.decode(FilRepResponse.self, from: data)
        
        return filRepResponse.miners
    }
}

public enum Region: String, CustomStringConvertible {
    case Asia
    case Europe
    case Africa
    case Oceania
    case SouthAmerica = "South America"
    case CentralAmerica = "Central America"
    case NorthAmerica = "North America"
    public var description: String {
        return self.rawValue
    }
}

public enum SortingOption: String, CustomStringConvertible {
    case uptime
    case rawPower
    case qualityAdjPower
    case freeSpace
    case score
    case averageStorageDealsPrice
    case noPenalties
    case dataStored
    public var description: String {
        return self.rawValue
    }
}

public enum Order: String, CustomStringConvertible {
    case asc, desc
    public var description: String {
        return self.rawValue
    }
}
