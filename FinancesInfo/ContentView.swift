//
//  ContentView.swift
//  FinancesInfo
//
//  Created by Vinicius Guimarães on 15/10/23.
//

import SwiftUI
import Flutter

struct ContentView: View {
    @EnvironmentObject var flutterDependencies: FlutterDependencies
    @State private var results = [ItemInfo]()
    
    var body: some View {
        VStack {
    
            Button("Ver detalhes PETRA4") {
                showFlutter(item: results)
            }
            .task {
                await loadData()
            }
            .disabled(results.isEmpty)
        
        }
        .padding()
    }
    
    func showFlutter(item: [ItemInfo]) {
        // Get the RootViewController.
        guard
          let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
          let window = windowScene.windows.first(where: \.isKeyWindow),
          let rootViewController = window.rootViewController
        else { return }

        // Create the FlutterViewController.
        let flutterViewController = FlutterViewController(
          engine: flutterDependencies.flutterEngine,
          nibName: nil,
          bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        

        do {
            print("start enconding")
            let jsonData = try JSONEncoder().encode(item)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("start enconding \(jsonString)")
                let methodChannel = FlutterMethodChannel(name: "your_channel_name",binaryMessenger: flutterViewController as! FlutterBinaryMessenger)

                methodChannel.invokeMethod("yourMethodName", arguments: jsonString)
            }
        } catch {
            print("Error encoding ItemInfo to JSON: \(error)")
        }

        
        
        rootViewController.present(flutterViewController, animated: true)
      }
    
    func loadData() async {
        guard let url = URL(string: "https://query2.finance.yahoo.com/v8/finance/chart/PETR4.SA?range=1mo&interval=1d") else {
            print("Invalid URL")
            return
        }
        
        do {
            print("Loading data")
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Loading \(data)")
            
            let stocke = try? JSONDecoder().decode(Stocke.self, from: data)
            
            if let stocke = try? JSONDecoder().decode(Stocke.self, from: data) {
                let stockData = stocke.chart.result.first
                let stockTimes = stockData?.timestamp
                let stockValueData = stockData?.indicators.quote.first
     
                let stockVariation = stockTimes?.enumerated().map { (index, time) in
                    let closing = stockValueData?.close[index] ?? 0
                    let percentage: Double
                    if index > 0 {
                        let prevValue = stockValueData?.close[index - 1] ?? 0
                        let diff = closing
                        percentage = ((closing - prevValue) / prevValue) * 100
                    } else {
                        percentage = 0.0
                    }
                    let totalPercentage: Double
                    if index > 0 {
                        let prevValue = stockValueData?.close[0] ?? 0
                        let diff = closing
                        totalPercentage = ((closing - prevValue) / prevValue) * 100
                    } else {
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
                
                results = stockVariation ?? []
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct ItemView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ": ")
                .bold()
            Text(value)
                .italic()
        }
    }
}

func formatDate(fromTimestamp timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    return dateFormatter.string(from: date)
}

func formatCurrency(_ amount: Double) -> String {
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


#Preview {
    ContentView()
}
