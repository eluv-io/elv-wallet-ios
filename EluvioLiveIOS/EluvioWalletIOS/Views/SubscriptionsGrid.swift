//
//  SubscriptionsGrid.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-10-08.
//

import SwiftUI


struct SubscriptionsGrid: View {
    var title: String = ""
    var titleImageUri: String = ""
    @State var seeMore = false
    let rows = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    let row = [
        GridItem(.flexible())
    ]
    
    var marketplaces : [MarketplaceModel]
    
    var width : CGFloat = 100
    var height : CGFloat = 150
    var addButton = false
    
    var body: some View {
        VStack {
            HStack(alignment:.center) {
                if(!titleImageUri.isEmpty){
                    AsyncImage(url: URL(string: titleImageUri)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .cornerRadius(5)
                            .shadow(radius: 3)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                if(!title.isEmpty){
                    Text(title).font(.title3).bold()
                }
                
                if(addButton){
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18)
                        .foregroundColor(Color.blue)
                        .padding(.leading)
                }
                
                
                Spacer()
            }.padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: seeMore ? rows : row, alignment: .firstTextBaseline) {
                        ForEach(marketplaces) { market in
                            //TODO: using test sale nfts, use the marketplace's
                            NavigationLink(destination: MarketView(nfts: test_sale_NFTs, marketplace: market)) {
                                MarketGridItem(market: market, width: width, height: height)
                            }
                        }
                }
                .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                  }
                }
                .frame(height: seeMore ? height*2 + 200 : height+50)
            }.ignoresSafeArea(edges: .vertical)
            Divider().padding()
        }
    }
}

struct MarketGridItem: View {
    var market: MarketplaceModel
    var width: CGFloat = 150
    var height: CGFloat = 200
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: market.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width,height: height-50)
                    .cornerRadius(20)
                    .shadow(radius: 3)
            } placeholder: {
                ProgressView()
            }.padding()
            
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(String(format:"%d items",1232))
                        .font(.system(size: 10))
                        .foregroundColor(Color.indigo)
                    Text(String(format:"%dK subs",232))
                        .font(.system(size: 10))
                        .foregroundColor(Color.indigo)
                }.padding(.bottom,5)
                
                Text(market.display_name)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.headerForeground)
                    .lineLimit(1)
                
                Text(market.description)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(Color.gray)
                    .frame(width: width)
            }
        }
    }
}

struct SubscriptionsGrid_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsGrid(title: "Subscriptions", marketplaces: test_marketplaces)
    }
}
