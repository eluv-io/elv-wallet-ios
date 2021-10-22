//
//  AchievementsView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-10-13.
//

import SwiftUI

struct AchievementsView: View {

    var title: String
    var achievements : [AchievementModel]
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

        LazyVGrid(columns: gridOption ? columns : column , alignment: .center) {
            ForEach(achievements) { achievement in
                achievementCard(achievement: achievement)
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

struct achievementCard: View {
    var achievement: AchievementModel
    var width: CGFloat = 150
    var height: CGFloat = 150
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: achievement.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .cornerRadius(5)
                    .shadow(radius: 3)
            } placeholder: {
                ProgressView()
            }.padding()
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(achievement.display_name)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.headerForeground)
                        .lineLimit(1)
                    Spacer()
                }
                Text(achievement.description)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(Color.gray)
                
            }
            .padding(.trailing)
        }
        .background(Color.translucent)
        .cornerRadius(10)
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(title:"Achievements", achievements: test_profile.achievements)
    }
}


