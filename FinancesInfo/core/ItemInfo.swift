//
//  ItemInfo.swift
//  FinancesInfo
//
//  Created by Vinicius Guimarães on 15/10/23.
//

import Foundation


struct ItemInfo: Identifiable, Codable {
    var id = UUID()
    let day: String
    let date: String
    let value: String
    let dailyVariation: String
    let totalVariation: String
    let stockVariation: VariationInfo
}

struct VariationInfo: Codable {
    let timeStamp: Int
    let max: Double
    let min: Double
    let opening: Double
    let closing: Double
    let variation: Double
    let totalVariation: Double
}
