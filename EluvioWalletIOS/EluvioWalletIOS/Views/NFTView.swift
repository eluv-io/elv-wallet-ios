//
//  NFTView.swift
//  NFTView
//
//  Created by Wayne Tran on 2021-08-11.


import SwiftUI

struct NFTView: View {
    @State var nft = NFTModel()
    var isForsale = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: URL(string: nft.metadata.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .overlay(Color.black.opacity(0.3))
                    .cornerRadius(15)
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Image(systemName: "a.square.fill").foregroundColor(Color.white.opacity(0.8))
                    Text(nft.metadata.creator)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white.opacity(0.8))
                        .textCase(.uppercase)
                }
                Text(nft.metadata.displayName).font(.title)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                Spacer()
                Text(nft.metadata.description)
                    .lineLimit(2)
                    .foregroundColor(Color.white)                
            }.padding()
            .padding(.horizontal, 5)
        }
        .padding(.horizontal,0)
        .padding(.vertical, 10)
        .shadow(color: Color.black, radius: 5)
        .frame(height: 300)
    }
}

struct NFTView_Previews: PreviewProvider {
    static var previews: some View {
        NFTView(nft: test_NFTs[0])
            .listRowInsets(EdgeInsets())
    }
}
