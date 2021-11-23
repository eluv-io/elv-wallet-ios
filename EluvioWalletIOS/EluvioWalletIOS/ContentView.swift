//
//  ContentView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-07-14.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fabric: Fabric

    
    var body: some View {
        
        MainView().preferredColorScheme(colorScheme)
            .fullScreenCover(isPresented: $fabric.isLoggedOut) {
            Spacer()
            SignInView()
                .preferredColorScheme(colorScheme)
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
