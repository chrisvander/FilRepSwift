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

public struct Miner: Codable {
    let id: Int
    let address: String
    let status: Bool
    let uptimeAverage: Float
    let price: String
    let rawPower: String
    let qualityAdjPower: String
    let isoCode: String
    let city: String
    let region: String
    let freeSpace: String
    let storageDeals: MinerStorageDeals
    let scores: MinerScores
    
    public struct MinerStorageDeals: Codable {
        let total: Int
        let noPenalties: Int
        let successRate: Float
        let averagePrice: String
        let dataStored: String
        let slashed: Int
    }
    
    public struct MinerScores: Codable {
        let total: Int
        let uptime: Int
        let storageDeals: Int
        let committeedSectorsProofs: Int
    }
}
