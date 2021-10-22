//
//  HViewGrid.swift
//  HViewGrid
//
//  Created by Wayne Tran on 2021-09-28.
//

import SwiftUI


struct HViewGrid: View {
    var title: String
    var subtitle: String
    var titleLink: AnyView?
    var titleImageUri: String
    @State var seeMore: Bool
    @State private var linkActive: Bool
    
    let rows = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    let row = [
        GridItem(.flexible())
    ]
    
    var nfts : [NFTModel]
    
    var width : CGFloat
    var height : CGFloat
    
    init(title: String = "",
         subtitle: String = "",
         titleLink: AnyView? = nil,
         titleImageUri: String = "",
         seeMore: Bool = false,
         nfts: [NFTModel],
         width: CGFloat = 100,
         height: CGFloat = 150
    ){
        print("HViewGrid title: " + title)
        self.title = title
        self.subtitle = subtitle
        self.titleLink = titleLink
        self.titleImageUri = titleImageUri
        self.seeMore = seeMore
        self.nfts = nfts
        self.width = width
        self.height = height
        self.linkActive = false
    }
    
    var titleView: some View {
        Group {
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
            
            VStack(spacing:20){
                if(!title.isEmpty){
                    Text(title).font(.title3).bold()
                }
                if(!subtitle.isEmpty){
                    Text(subtitle).font(.subheadline).bold().foregroundColor(.gray)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                if(linkActive){
                    NavigationLink(destination: titleLink) {
                        titleView
                
                    /*
                    Button(action: {
                        withAnimation {
                            self.seeMore.toggle()
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(seeMore ? 90 : 0))
                            .foregroundColor(.black)
                    })
                     */
                    }.buttonStyle(PlainButtonStyle())
                }else{
                    titleView
                }
            }.padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: seeMore ? rows : row, alignment: .top) {
                        ForEach(nfts) { nft in
                            NavigationLink(destination: NFTDetail(nft: nft)) {
                                doubleColumn(nft: nft, width: width, height: height)
                                    .padding(2)
                            }
                        }
                }
                .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {

                  }
                }
                .padding(.leading)
                .frame(height: seeMore ? height + 200 : height + 20)
                
            }.ignoresSafeArea(edges: .vertical)

            Divider().padding()
        }
        .onAppear {
            if(titleLink != nil){
                self.linkActive = true
                print("linkActive = true")
            }
        }
    }
}

struct HView_Previews: PreviewProvider {
    static var previews: some View {
        HViewGrid(title: "Recent", titleLink:AnyView(Text("")),
                  nfts: test_NFTs)
    }
}
