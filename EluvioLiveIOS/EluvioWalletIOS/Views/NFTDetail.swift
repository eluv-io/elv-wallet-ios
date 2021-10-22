//
//  NFTDetail.swift
//  NFTDetail
//
//  Created by Wayne Tran on 2021-09-27.
//

import SwiftUI

struct DetailTitle: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var search = false
    @State var searchText = ""
    var title = ""
    var nft: NFTModel
    
    var body: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.headerForeground)
            }
            Text(title).font(.title2).bold().foregroundColor(.headerForeground).lineLimit(1)
            Spacer()
        }
        .navigationBarTitle(title)
    }
}


struct NFTDetail: View {
    @State var nft = NFTModel()

    var body: some View {
        VStack(alignment: .leading) {
            DetailTitle(title:nft.display_name, nft:nft)
            AsyncImage(url: URL(string: nft.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .overlay(Color.black.opacity(0.3))
                    .cornerRadius(15)
            } placeholder: {
                ProgressView()
            }
            HStack{
                Button(action: {

                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.headerForeground).font(.title2)
                }
                
                Button(action: {

                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.headerForeground).font(.title2)
                }
                Spacer()
                Text(String(format:"%1.2f ELV",nft.price_tokens))
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
                if(nft.is_for_sale){
                    HStack{
                        Button(action: {
                            print("Buy!")
                        }) {

                            Text("BUY")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .padding([.top, .bottom], 6)
                                .padding([.leading, .trailing], 25)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                        }
                    }
                    .padding([.leading])
                }else{
                    Menu {
                        Button(action: {}) {
                            Label("Sell", systemImage: "dollarsign.circle")
                        }
                        
                        Button(action: {}) {
                                Label("Delete", systemImage: "trash.circle")
                            }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .background(.thinMaterial)
                }
                
            }
            
            ScrollView(.horizontal, showsIndicators: false){
                VStack{

                    HStack(alignment:.center, spacing: 20){
                        VStack{
                            Text("Creator").font(.footnote).foregroundColor(Color.gray)
                            Text(nft.creator)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                        }
                        Divider()
                            .frame(height: 25.0)
                        
                        VStack{
                            Text("Edition").font(.footnote).foregroundColor(Color.gray)
                            Text(nft.edition_name)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                        }
                        Divider()
                            .frame(height: 25.0)
                        
                        VStack{
                            Text("Supply").font(.footnote).foregroundColor(Color.gray)
                            Text(String(format:"%d/%d",nft.edition_number, nft.total_supply))
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                        }
                        Divider()
                            .frame(height: 25.0)

                        VStack{
                            Text("Created At").font(.footnote).foregroundColor(Color.gray)
                            Text(nft.created_at)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                        }

                    }

                }
            }

            Spacer()
                .frame(height: 20.0)
            Text("Description").font(.headline).foregroundColor(.headerForeground)
            Text(nft.description).foregroundColor(.headerForeground)
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
    
}

struct NFTDetail_Previews: PreviewProvider {
    static var previews: some View {
        NFTDetail(nft: test_NFTs[0])
                .listRowInsets(EdgeInsets())
    }
}
