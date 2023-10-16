//
//  StockRepository.swift
//  FinancesInfo
//
//  Created by Vinicius Guimarães on 16/10/23.
//

import Foundation


class StockRepository {
    func loadStocks() async -> Result<[ItemInfo], Error> {
        return await Task { () -> [ItemInfo] in
            let url = URL(string: "https://query2.finance.yahoo.com/v8/finance/chart/PETR4.SA?range=1mo&interval=1d")
            let (data, _) = try await URLSession.shared.data(from: url!)
            let stocke = try JSONDecoder().decode(Stocke.self, from: data)
            let stockData = stocke.chart.result.first
            let stockTimes = stockData?.timestamp
            let stockValueData = stockData?.indicators.quote.first
         
            let stockVariation = stockTimes?.enumerated().map { (index, time) in
                let closing = stockValueData?.close[index] ?? 0
                let percentage: Double
                let totalPercentage: Double
                if index > 0 {
                    let prevValue = stockValueData?.close[index - 1] ?? 0
                    let initialValue = stockValueData?.close[0] ?? 0
                    let diff = closing
                    
                    percentage = ((closing - prevValue) / prevValue) * 100
                    totalPercentage = ((closing - initialValue) / initialValue) * 100
                } else {
                    percentage = 0.0
                    totalPercentage = 0.0
                }
                
                let variation = VariationInfo(
                    timeStamp: time,
                    max: stockValueData?.high[index] ?? 0,
                    min: stockValueData?.low[index] ?? 0,
                    opening: stockValueData?.quoteOpen[index] ?? 0,
                    closing: closing,
                    variation: percentage,
                    totalVariation: totalPercentage
                )
                
                let info = ItemInfo(
                    day: "\(index + 1)",
                    date: formatDate(fromTimestamp: variation.timeStamp),
                    value: formatCurrency(variation.closing),
                    dailyVariation: "\(String(format: "%.2f", variation.variation))%",
                    totalVariation: "\(String(format: "%.2f", variation.totalVariation))%",
                    stockVariation: variation
                )
                
                return info
            }
               
            
            return stockVariation!
        }.result
    }
    
    private func formatDate(fromTimestamp timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: date)
    }

    private func formatCurrency(_ amount: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "R$"
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
        
        if let formattedAmount = currencyFormatter.string(from: NSNumber(value: amount)) {
            return formattedAmount
        } else {
            return "0.00 R$"
        }
    }
}
