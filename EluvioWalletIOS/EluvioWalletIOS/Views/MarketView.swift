//
//  MarketView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-10-08.
//

import SwiftUI

struct MarketTitle: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var search = false
    @State var searchText = ""
    var title = ""
    var subtitle = ""
    var rating : Float = 0.0
    var logoUri = ""
    
    var body: some View {
        HStack(spacing:20) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.headerForeground)
            }
            AsyncImage(url: URL(string: logoUri)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            VStack(alignment:.leading){
                Text(title).font(.title2).bold().foregroundColor(.headerForeground).lineLimit(1)
                Text(subtitle).font(.footnote).fontWeight(.semibold).foregroundColor(.gray).lineLimit(1)
                StarsView(size:15,rating: rating)
            }
            Spacer()
        }
        .ignoresSafeArea()
        .padding()
        .padding(.top,20)
    }
}

struct MarketView: View {
    var nfts : [NFTModel]
    var marketplace: MarketplaceModel
    let columns = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    let column = [GridItem(.flexible())]
    
    var body: some View {
        ZStack(alignment:.top) {
                LinearGradient(gradient: Gradient(colors: [Color.mainBackground1, Color.mainBackground2]),
                               startPoint: .topTrailing, endPoint: .center)
                GeometryReader { geometry in
                    ScrollView {
                            VStack{
                                //Spacer().frame(height:20)
                                MarketTitle(title:marketplace.display_name,
                                            subtitle:marketplace.creator,
                                            rating: marketplace.rating,
                                            logoUri: marketplace.image).background(Color.tinted)
                        
                                HStack(alignment:.center, spacing: 10){
                                    VStack{
                                        Text("Items").font(.footnote).foregroundColor(Color.indigo).lineLimit(1)
                                        Text(marketplace.items)
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                            .foregroundColor(Color.indigo)
                                    }
                                    Divider()
                                        .frame(height: 25.0)
                                    
                                    VStack{
                                        Text("Subscribers").font(.footnote).foregroundColor(Color.indigo).lineLimit(1)
                                        Text(marketplace.subscribers)
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                            .foregroundColor(Color.indigo)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        print("Buy!")
                                    }) {
                                        HStack(spacing:0) {
                                            Image(systemName: "star")
                                                .resizable()
                                                .frame(width: 14, height: 14)
                                                .padding(.leading, 10)
                                                .padding(.trailing, 3)
                                            Text("SUBSCRIBE")
                                                .font(.system(size: 10))
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .padding([.top, .bottom, .trailing], 10)
                                                .frame(width:80)
                                        }
                                        .background(Color.indigo)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                    }
                                    
                                }
                                .padding([.leading,.trailing])
                                Divider()
                            }

                        HViewGrid(title:"Recent", nfts: nfts, width:geometry.size.width-50, height: geometry.size.width/1.6)
                        HViewGrid(title:"Free",seeMore: true, nfts: nfts)
                        HViewGrid(title:"Common",seeMore: true, nfts: nfts)
                        HViewGrid(title:"Gold Pack",seeMore: true, nfts: nfts)
                    }
                    .ignoresSafeArea()
                    .padding(.top)
                }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}


struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView(nfts: test_sale_NFTs, marketplace: test_marketplaces[0])
    }
}
