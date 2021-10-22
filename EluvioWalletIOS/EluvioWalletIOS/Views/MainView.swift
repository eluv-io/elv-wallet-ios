//
//  MainView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-08-10.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            DiscoveryView(nfts: test_sale_NFTs, marketplaces: test_marketplaces)
                .preferredColorScheme(colorScheme)
              .tabItem {
                 Image(systemName: "bag.badge.plus")
                 Text("Discover")
              }
            
            WalletView(nfts: test_NFTs).preferredColorScheme(colorScheme)
              .tabItem {
                 Image(systemName: "w.square.fill")
                 Text("Wallet")
            }
            
            ProfileView(nfts: test_NFTs, profile:test_profile).preferredColorScheme(colorScheme)
              .tabItem {
                 Image(systemName: "person.crop.circle")
                 Text("Profile")
            }.preferredColorScheme(colorScheme)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.light)
    }
}
