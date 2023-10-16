//
//  FinancesInfoApp.swift
//  FinancesInfo
//
//  Created by Vinicius Guimarães on 15/10/23.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
  let flutterEngine = FlutterEngine(name: "my flutter engine")
  init(){
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
  }
}


@main
struct FinancesInfoApp: App {
    @StateObject var flutterDependencies = FlutterDependencies()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(flutterDependencies)
        }
    }
}
