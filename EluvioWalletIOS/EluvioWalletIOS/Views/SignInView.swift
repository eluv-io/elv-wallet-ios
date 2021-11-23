//
//  SignInView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-08-10.
//

import SwiftUI
import AuthenticationServices
import SwiftEventBus

class Subscriber {
    var view : Any
    init(view: Any){
        self.view = view
    }
}

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fabric: Fabric
    
    var subscriber : Subscriber?
    
    init(){
        print("SignInView init()")
        self.subscriber = Subscriber(view:self)
        /*print("\(self.fabric)")
        if(!self.fabric.isLoggedOut){
            self.presentationMode.wrappedValue.dismiss()
        }
         */
        
    }


    var body: some View {
        VStack(alignment: .center, spacing: 30){
            VStack(alignment: .center, spacing:20){
                Image("wallet_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
                HStack(spacing:5){
                    Text("ELUV.IO")
                        .font(.custom("Helvetica Neue", size: 40))
                        .fontWeight(.thin)
                        .foregroundColor(Color.headerForeground)
                        .selfSizeMask(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple,.red, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                        )
                    Text("Wallet")
                        .font(.custom("Helvetica Neue", size: 40))
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
                .frame(height: 10.0)
            
        
            
            Button(action: {
                fabric.signIn()
            }) {
                Text("Sign In")
                .font(.headline)
                .foregroundColor(Color.white)
                .background(Color.black)
                .padding()
                .cornerRadius(15.0)
            }.frame(width: 200, height: 50, alignment: .center)
        
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Skip")
                .foregroundColor(Color.headerForeground)
            }
        }
        .background(colorScheme == .dark ? .black : .white)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().preferredColorScheme(.dark)
    }
}
