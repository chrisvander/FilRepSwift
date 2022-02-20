import Foundation

@available(macOS 10.15, *)
public struct FilRepSwift {
    let apiUrl: String = "https://api.filrep.io/api/v1/miners"
    
    private func getJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.nonConformingFloatDecodingStrategy =
          .convertFromString(
              positiveInfinity: "+Infinity",
              negativeInfinity: "-Infinity",
              nan: "NaN")
        return decoder
    }
    
    private func createURLQuery(title: String, value o: CustomStringConvertible?) -> URLQueryItem? {
        (o != nil) ? URLQueryItem(name: title, value: String(describing: o!)) : nil
    }
    
    private func createURL(
        _ offset: Int? = nil,
        _ limit: Int? = 10,
        _ sortBy: SortingOption? = nil,
        _ order: Order? = nil,
        _ search: String? = nil,
        _ region: Region? = nil
    ) -> URL {
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
        
        return url
    }
    
    public func getMiners(
        offset: Int? = nil,
        limit: Int? = 10,
        sortBy: SortingOption? = nil,
        order: Order? = nil,
        search: String? = nil,
        region: Region? = nil,
        completion: @escaping (Result<[Miner], Error>) -> Void
    ) -> Void {
        let url = self.createURL(offset, limit, sortBy, order, search, region)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if (error != nil) {
                completion(Result.failure(error!))
            }
            do {
                let filRepResponse = try self.getJSONDecoder().decode(FilRepResponse.self, from: data!)
                completion(Result.success(filRepResponse.miners))
            } catch {
                completion(Result.failure(error))
            }
            
        }
        task.resume()
    }
    
    @available(macOS 12.0, *)
    public func getMiners(
        offset: Int? = nil,
        limit: Int? = 10,
        sortBy: SortingOption? = nil,
        order: Order? = nil,
        search: String? = nil,
        region: Region? = nil
    ) async throws -> [Miner] {
        let url = self.createURL(offset, limit, sortBy, order, search, region)
        let (data, _) = try await URLSession.shared.data(from: url)
        let filRepResponse = try self.getJSONDecoder().decode(FilRepResponse.self, from: data)
        return filRepResponse.miners
    }
}

public enum Region: String, CustomStringConvertible, Codable {
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
