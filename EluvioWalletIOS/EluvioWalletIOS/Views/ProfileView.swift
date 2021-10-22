//
//  ProfileView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-10-10.
//

import SwiftUI

struct ProfileTitle: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var search = false
    @State var searchText = ""
    var title = ""
    var subtitle = ""
    var rating : Float = 0.0
    var logoUri = ""
    var showBackButton = false
    
    var body: some View {
        HStack(spacing:20) {
            if(showBackButton){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.headerForeground)
                }
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
                Text(title).font(.title2).bold().foregroundColor(.white).lineLimit(1)
                Text(subtitle).font(.footnote).fontWeight(.semibold).foregroundColor(.indigo).lineLimit(1)
            }
            Spacer()
        }
        .padding()
    }
}

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    var nfts : [NFTModel]
    var profile: ProfileModel
    let columns = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    let column = [GridItem(.flexible())]
    let isCurrent : Bool = true
    @State private var darkMode = false
    @State private var setting1 = false
    @State private var setting2 = false
    
    var body: some View {
        NavigationView{
            ZStack(alignment:.top) {
                    LinearGradient(gradient: Gradient(colors: [Color.mainBackground1, Color.mainBackground2]),
                                   startPoint: .topTrailing, endPoint: .center)
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(alignment:.leading){
                                    Spacer().frame(height:20)
                                    ProfileTitle(title:profile.display_name,
                                                 subtitle:profile.address,
                                                 logoUri: profile.image,
                                                 showBackButton: !isCurrent)

                                    HStack(alignment:.center, spacing: 10){
                                        Spacer()

                                        VStack{
                                            Text("Sold").font(.footnote).foregroundColor(Color.indigo).lineLimit(1)
                                            Text(profile.num_sold)
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .foregroundColor(Color.white)
                                        }
                                        Divider()
                                            .frame(height: 25.0)
                                        
                                        VStack{
                                            Text("Followers").font(.footnote).foregroundColor(Color.indigo).lineLimit(1)
                                            Text(profile.followers)
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .foregroundColor(Color.white)
                                        }
                                        Divider()
                                            .frame(height: 25.0)
                                        
                                        VStack{
                                            Text("Following").font(.footnote).foregroundColor(Color.indigo).lineLimit(1)
                                            Text(profile.following)
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .foregroundColor(Color.white)
                                        }
                                        Divider()
                                            .frame(height: 25.0)
                                        
                                        VStack{
                                            Text("Balance").font(.footnote).foregroundColor(Color.indigo).lineLimit(1)
                                            Text(profile.tokens)
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .foregroundColor(Color.white)
                                        }

                                        
                                        Spacer()
                                        
                                        /*
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
                                         */
                                        
                                    }
                                    .padding([.leading,.trailing])
                                    Divider()
                            }
                            /*
                            .background(
                                LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [.black,.profileHeader1,.profileHeader2,.black] : [Color.tinted]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                             */
                            .background(Color.tinted)
                            
                            SubscriptionsGrid(title: isCurrent ? "My Marketplaces" : "Marketplaces", marketplaces: profile.marketplaces, width: 200,height: 140, addButton:true)
                            
                            AchievementsView(title: "Achievements", achievements: profile.achievements)

                            HStack{
                                Text("Settings").font(.title3).bold()
                                    .lineLimit(1)
                                    .padding()
                                Spacer()
                            }
                            /*
                            Group{
                                Divider()
                                    .padding()
                                
             
                                Toggle(isOn: $darkMode) {
                                    HStack() {
                                        Image(systemName: "sun.min")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 3)
                                            .foregroundColor(.gray)
                                        Text("Dark Mode")
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                            .padding([.top, .bottom, .trailing], 10)
                                            .foregroundColor(.headerForeground)
                                    }
                                }
                                .padding([.leading,.trailing])
                            }
                                 */
                            
                            Group {
                                Divider()
                                    .padding()
                                
                                Toggle(isOn: $setting1) {
                                    HStack() {
                                        Image(systemName: "gear")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 3)
                                            .foregroundColor(.gray)
                                        Text("Setting 1")
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                            .padding([.top, .bottom, .trailing], 10)
                                            .foregroundColor(.headerForeground)
                                    }
                                }
                                .padding([.leading,.trailing])
                            }
                            
                            Group{
                            
                                Divider()
                                    .padding()
                                
                                Toggle(isOn: $setting2) {
                                    HStack() {
                                        Image(systemName: "waveform.circle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 3)
                                            .foregroundColor(.gray)
                                        Text("Setting 1")
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                            .padding([.top, .bottom, .trailing], 10)
                                            .foregroundColor(.headerForeground)
                                    }
                                }
                                .padding([.leading,.trailing])
                                
                                Divider()
                                    .padding()
                                Spacer().frame(height:100)
                            }
                            
                        }
                        .ignoresSafeArea()
                        .padding(.top)
                    }
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(nfts: test_sale_NFTs, profile: test_profile)
    }
}
