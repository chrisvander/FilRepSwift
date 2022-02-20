//
//  File.swift
//  
//
//  Created by Chris Vanderloo on 2/18/22.
//

import Foundation

public struct FilRepResponse: Codable {
    let miners: [Miner]
    let pagination: Pagination
    public struct Pagination: Codable {
        let total: Int
        let limit: Int
    }
}

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

protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Int: StringRepresentable {}
