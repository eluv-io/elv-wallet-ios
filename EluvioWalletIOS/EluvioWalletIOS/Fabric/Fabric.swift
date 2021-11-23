//
//  Fabric.swift
//  EluvioWalletIOS
//
//  Created by Wayne Tran on 2021-11-01.
//

import Foundation
import Auth0
import SwiftEventBus
import Base58Swift
import Alamofire

var APP_CONFIG : AppConfiguration = loadJsonFile("configuration.json")
enum FabricError: Error {
    case invalidURL
    case configError
    case unexpectedResponse
    case noLogin
    case badInput
}

class Fabric: ObservableObject {
    var configUrl = ""
    @Published
    var configuration : FabricConfiguration? = nil
    @Published
    var login :  LoginResponse? = nil
    @Published
    var isLoggedOut = true
    
    var profileData: [String: Any] = [:]
    @Published
    var wallet: [NFTModel] = []
    
    var signer : RemoteSigner? = nil
    var currentEnpointIndex = 0
    
    init(configUrl: String){
        self.configUrl = configUrl
        print("Fabric init config_url \(self.configUrl)");
    }
    
    func getEndpoint() throws -> String{
        guard let config = self.configuration else {
            throw FabricError.configError
        }
        
        let endpoint = config.getFabricAPI()[self.currentEnpointIndex]
        if(endpoint.isEmpty){
            throw FabricError.configError
        }
        return endpoint
    }
    
    
    @MainActor
    func connect() async throws {

        guard let url = URL(string: self.configUrl) else {
            throw FabricError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let str = String(decoding: data, as: UTF8.self)
        
        print("Fabric config response: \(str)")

        let config = try JSONDecoder().decode(FabricConfiguration.self, from: data)
        self.setConfiguration(configuration:config)
        guard let ethereumApi = self.configuration?.getEthereumAPI() else {
            throw FabricError.configError
        }
        self.signer = RemoteSigner(endpoints: ethereumApi)
    }
    
    func setConfiguration(configuration: FabricConfiguration){
        self.configuration = configuration
        print("QSPACE_ID: \(self.configuration?.qspace.id)")
    }
    
    func setLogin(login:  LoginResponse){
        self.login = login
        self.isLoggedOut = false
        print("Fabric login addr: \(self.login?.addr)")
        Task {
            do{
                print("Account ID: \(try getAccountId())")
                let profileData = try await self.signer!.getProfileData(contentSpaceId: self.configuration!.getQspaceId(), accountId: try getAccountId())
                print("Profile DATA: \(profileData)")
                var wallet : [NFTModel] = []
                if let nfts = profileData["NFTs"] as? [String: AnyObject] {
                
                    for (iten, nftObj) in nfts{
                        print("nft: \(type(of:nftObj))")
                        if let nft = nftObj[0] as? Dictionary<String, AnyObject> {
                            if let tokenUri = nft["TokenUri"] as? String {
                                print("tokenUri \(tokenUri)")
                                let url = URL(string:tokenUri)!
                                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                                let path = components.path
                                    let query = components.query ?? ""
                                    
                                    let pathsArr = path.components(separatedBy:"/")
                                    if(pathsArr.count > 3){
                                        let versionHash = pathsArr[2]
                                        print("versionHash \(versionHash)")
                                        if let newUrl = URL(string: try self.getEndpoint() + path + "?" + query) {
                                            print("new enpoint: \(newUrl)")
                                            let nftmeta = try await getNFTMeta(tokenUri: newUrl.absoluteString)
                                            print("tokenUri response: \(nftmeta)")
                                            var nftmodel = NFTModel()
                                            
                                            //TODO: get id
                                            nftmodel.id = versionHash
                                            nftmodel.versionHash = versionHash
                                            nftmodel.metadata = nftmeta
                                            wallet.append(nftmodel)
                                        }
                                    }
                                    
                                }
                            }
                       }
                    }
                }
                self.wallet = wallet
                self.profileData = profileData
            }catch{
                print ("Error: \(error)")
            }
        }
    }
    
    func signOut(){
        print("Fabric: signOut()")
        guard let config = self.configuration else
        {
            print("Not configured.")
            return
        }
        
        
        Auth0
            .webAuth()
            .clearSession(federated: false) { result in
                if result {
                    print("Sign Out successful.")
                    self.login = nil
                    self.isLoggedOut = true
                }else{
                    print("Sign Out unsuccessful.")
                }
            }
    }
    
    func signIn(){
        print("Fabric: signIn()")
        guard let config = self.configuration else
        {
            print("Not configured.")
            return
        }
        
        Auth0
            .webAuth()
            .scope("openid profile email")
            .audience("https://prod-elv.us.auth0.com/userinfo")
            .start { result in
                switch result {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
                    print("Credentials: \(credentials)")

                    
                    print("Web Auth0 Success: idToken: \(credentials.idToken)")
                    print("Web Auth0 Success: accessToken: \(credentials.accessToken)")
                    print("Web Auth0 Success: tokenType: \(credentials.tokenType)")
                    print("Web Auth0 Success: refreshToken: \(credentials.refreshToken)")
                    
                    guard let accessToken: String = credentials.accessToken else {return}
                    guard let idToken: String = credentials.idToken else {return}
                    //guard let refreshToken: String = credentials.refreshToken else {return}
                    //guard let tokenType: String = credentials.tokenType else {return}
                    
                    let urlString = config.getAuthServices()[0] + "/wlt/login/jwt"
                    guard let url = URL(string: urlString) else {
                        //throw FabricError.invalidURL
                        return
                    }
                    

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
                    
                    let json: [String: Any] = ["ext": [:]]
                    request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
                    
                    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                        DispatchQueue.main.async {
                            do{
                                guard let data = data else {
                                    throw FabricError.unexpectedResponse
                                }
                                
                                let str = String(decoding: data, as: UTF8.self)
                                
                                print("Fabric login response: \(str)")

                                // Parse the JSON data
                                let login = try JSONDecoder().decode(LoginResponse.self, from: data)
                                self.setLogin(login: login)
                                
                            }catch{
                                print(error)
                            }
                        }
                    })
                    
                    task.resume()
                
                }
        }
    }
    
    
    func getAccountId() throws -> String {
        guard let address = self.login?.addr else
        {
            throw FabricError.noLogin
        }
        
        guard let bytes = HexToBytes(address) else {
            throw FabricError.badInput
        }
        
        let encoded = Base58.base58Encode(bytes)
        
        return "iusr\(encoded)"
    }
    
    /*
    func getNFTData(tokenUri: String ) async throws -> [String: AnyObject] {
            return try await withCheckedThrowingContinuation({ continuation in
                
                do {
                    AF.request(tokenUri)
                        .responseJSON { response in
                            debugPrint("Response: \(response)")
                    switch (response.result) {

                        case .success( _):
                            if let value = response.value as? [String: AnyObject] {
                                continuation.resume(returning: value)
                            }else{
                                continuation.resume(throwing: FabricError.unexpectedResponse)
                            }
                         case .failure(let error):
                            print("Request error: \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                         
                     }
                }
                }catch{
                    continuation.resume(throwing: error)
                }
            })
    }*/
    
    func getNFTMeta(tokenUri: String ) async throws -> NFTMetaResponse {
            return try await withCheckedThrowingContinuation({ continuation in
                    AF.request(tokenUri)
                        .validate()
                        .responseDecodable(of: NFTMetaResponse.self){ response in
                            debugPrint("Response: \(response)")
                    switch (response.result) {
                        case .success( _):
                            guard let value = response.value else {
                                continuation.resume(throwing: FabricError.unexpectedResponse)
                                return
                            }
                            continuation.resume(returning: value)
                         case .failure(let error):
                            print("Request error: \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                     }
                }
            })
    }
    
    
    
}


