//
//  EluvioLiveIOSApp.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-07-13.
//

import SwiftUI

@main
struct EluvioLiveIOSApp: App {
    @StateObject
    var fabric = Fabric(configUrl: APP_CONFIG.config_url)
    
    init(){
        print("App Init")
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fabric)
                .onAppear(perform: {
                    print("App OnAppear")
                    Task {
                        do {
                            try await fabric.connect()
                        } catch {
                            print("Request failed with error: \(error)")
                        }
                    }
                })
        }
    }
}
