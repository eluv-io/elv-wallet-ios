//
//  DiscoveryView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-08-03.
//

import SwiftUI

struct DiscoveryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var nfts : [NFTModel]
    var marketplaces : [MarketplaceModel]
    let columns = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    let column = [GridItem(.flexible())]
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack() {
                LinearGradient(gradient: Gradient(colors: [Color.mainBackground1, Color.mainBackground2]),
                               startPoint: .topTrailing, endPoint: .center)
                GeometryReader { geometry in
                    ScrollView {
                        Spacer(minLength: 20)
                        HViewGrid(title:"Featured", nfts: nfts, width:geometry.size.width-50, height: geometry.size.width/1.5)
                        HViewGrid(title:"Events", nfts: nfts, width:geometry.size.width/2, height: geometry.size.width/1.5)
                        LazyVGrid(columns: column , alignment: .center) {
                            ForEach(marketplaces) { market in
                                HViewGrid(title:market.display_name,
                                          titleLink: AnyView(MarketView(nfts:test_sale_NFTs, marketplace: market)),
                                          titleImageUri:market.image,
                                          seeMore: true,
                                          nfts: nfts)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Header(title: "Marketplace")
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
                        prompt: "Search..."
            )
        }
    }
}

func animateWithTimer(proxy: ScrollViewProxy) {
    let count: Int = 100
    let duration: Double = 30.0
    let timeInterval: Double = (duration / Double(count))
    var counter = 0
    let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer) in
        withAnimation(.linear) {
            proxy.scrollTo(counter, anchor: .center)
        }
        counter += 1
        if counter >= count {
            timer.invalidate()
        }
    }
    timer.fire()
}


struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView(nfts: test_sale_NFTs, marketplaces: test_marketplaces).preferredColorScheme(.dark)
    }
}
