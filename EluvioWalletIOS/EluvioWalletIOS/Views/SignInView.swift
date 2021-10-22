//
//  SignInView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-08-10.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
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
            
            SignInWithAppleButton(
                // 1.
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success (let authorization):
                        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                            print("Authorization successful! :\(appleIDCredential)")
                            let userId = appleIDCredential.user
                            let identityToken = appleIDCredential.identityToken
                            let authCode = appleIDCredential.authorizationCode
                            let email = appleIDCredential.email
                            let givenName = appleIDCredential.fullName?.givenName
                            let familyName = appleIDCredential.fullName?.familyName
                            let state = appleIDCredential.state
                            
                            print("userId :\(userId)")
                            print("identityToken :\(identityToken)")
                            print("authCode :\(authCode)")
                            print("email :\(email)")
                            print("givenName :\(givenName)")
                            print("familyName :\(familyName)")
                            
                            // Here you have to send the data to the backend and according to the response let the user get into the app.
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                    case .failure(let error):
                        print("Authorization failed: " + error.localizedDescription)
                    }
                }
            ).frame(width: 200, height: 50, alignment: .center)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
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
