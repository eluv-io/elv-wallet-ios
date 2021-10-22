//
//  NFTList.swift
//  NFTList
//
//  Created by Wayne Tran on 2021-09-27.
//

import SwiftUI

struct NFTList: View {

    var title: String
    var nfts : [NFTModel]
    @State private var editMode = EditMode.inactive
    let columns = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    let column = [GridItem(.flexible())]

    @State var search = false
    @State var searchText = ""
    @State var gridOption = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.title3).bold()
            }

            Spacer()
        }.padding(.horizontal)
        if gridOption {HViewGrid(title: "Recent", nfts: nfts)}
        
        LazyVGrid(columns: gridOption ? columns : column , alignment: .center) {
            ForEach(nfts) { nft in
                if gridOption {
                    NavigationLink(destination: NFTDetail(nft: nft)) {
                        doubleColumn(nft: nft)
                    }
                } else {
                    NavigationLink(destination: NFTDetail(nft: nft)) {
                        singleColumn(nft: nft)
                    }
                }
            }
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
          }
        }
        .padding(.horizontal)
        Divider().padding()

.navigationBarItems(leading: EditButton())
    }
}

struct singleColumn: View {
    var nft: NFTModel
    var body: some View {
        NFTView(nft:nft).padding()
    }
}

struct doubleColumn: View {
    var nft: NFTModel
    var width: CGFloat = 150
    var height: CGFloat = 200
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: nft.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height - 50)
                    .cornerRadius(5)
                    .shadow(radius: 3)
            } placeholder: {
                ProgressView()
            }
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(nft.display_name)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.headerForeground)
                        .lineLimit(1)
                    Spacer()
                    Text(String(format:"%d/%d",nft.edition_number, nft.total_supply))
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray)
                }
                Text(nft.edition_name)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(Color.gray)
                
                if(nft.is_for_sale){
                    HStack{
                        Button(action: {
                            print("Buy!")
                        }) {
                            HStack(spacing:0) {
                                Image(systemName: "e.circle.fill")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .padding(.leading, 4)
                                    .padding(.trailing, 3)
                                Text(String(format:"%.2f",nft.price_tokens))
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .padding([.top, .bottom, .trailing], 4)
                            }
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        }
                        Spacer()

                    }
                }
            }
        }
    }
}

struct NFTList_Previews: PreviewProvider {
    static var previews: some View {
        NFTList(title:"Wallet", nfts: test_NFTs)
    }
}

