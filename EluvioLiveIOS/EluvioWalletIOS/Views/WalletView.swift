//
//  ContentView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-07-14.
//

import SwiftUI

struct WalletView: View {
    var nfts : [NFTModel]
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack() {
                LinearGradient(gradient: Gradient(colors: [Color.mainBackground1, Color.mainBackground2]),
                               startPoint: .topTrailing, endPoint: .center)
                ScrollView {
                    Spacer(minLength:20)
                    HViewGrid(title:"Recent", nfts: nfts)
                    HViewGrid(title:"Favorites", nfts: nfts)
                    SubscriptionsGrid(title:"Subscriptions", marketplaces: test_marketplaces, width: 200,height: 140)
                    HViewGrid(title:"Masked Singer - Gold Pack Collection",
                              subtitle: "6/15 Collected",
                              seeMore: true, nfts: nfts)
                    
                    NFTList(title:"Events", nfts: nfts)
                    NFTList(title:"Items", nfts: nfts)
                }
                
            }
            .navigationBarTitle("",displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Header(title: "Wallet")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing:0) {
                        Image(systemName: "e.circle.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .padding(.leading, 4)
                            .padding(.trailing, 3)
                        Text("234332.3343").font(.subheadline).foregroundColor(.gray).lineLimit(1)
                    }
                    .foregroundColor(.gray)
                }
            }
            .navigationBarHidden(false)
            .searchable(text: $searchText,
                        placement: .sidebar,
                        prompt: "Search..."
                        
            )
            .onSubmit(of: .search) {
                
            }
        }
    }
}



struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(nfts: test_NFTs)
    }
}
