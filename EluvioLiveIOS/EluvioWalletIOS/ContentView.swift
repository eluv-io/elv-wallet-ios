//
//  ContentView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-07-14.
//

import SwiftUI

struct ContentView: View {
    @State private var showLogin = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            MainView().preferredColorScheme(colorScheme)
            .fullScreenCover(isPresented: $showLogin) {
                Spacer()
                SignInView().preferredColorScheme(colorScheme)
                Spacer()
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
