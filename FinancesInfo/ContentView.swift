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
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(
                where: {
                    $0.activationState == .foregroundActive && $0 is UIWindowScene
                }
            ) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }


        let flutterViewController = FlutterViewController(
          engine: flutterDependencies.flutterEngine,
          nibName: nil,
          bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        

        do {
            let jsonData = try JSONEncoder().encode(item)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let methodChannel = FlutterMethodChannel(
                    name: "your_channel_name",
                    binaryMessenger: flutterViewController as! FlutterBinaryMessenger
                )

                methodChannel.invokeMethod("yourMethodName", arguments: jsonString)
            }
        } catch {
            print("Error encoding ItemInfo to JSON: \(error)")
        }

        
        
        rootViewController.present(flutterViewController, animated: true)
      }
    
    func loadData() async {
        let repository = StockRepository()
        let result = await repository.loadStocks()
        switch result {
        case .success(let items):
            results = items
        case .failure(let error):
            print("error: \(error)")
        }
    }
}


#Preview {
    ContentView()
}
