//
//  RemoteSigner.swift
//  EluvioWalletIOS
//
//  Created by Wayne Tran on 2021-11-14.
//

import Foundation
import Alamofire
struct JRPCParams: Codable {
    var jsonrpc = "2.0"
    var id = 1
    var method: String
    var params: [String]
}

class RemoteSigner {
    var endpoints : [String]
    var currentEnpointIndex = 0

    init(endpoints: [String]){
        self.endpoints = endpoints
    }
    
    //TODO: implement fail over
    func getEndpoint() throws -> String{
        let endpoint = self.endpoints[self.currentEnpointIndex]
        if(endpoint.isEmpty){
            throw FabricError.configError
        }
        return endpoint
    }
    
    func getProfileData(contentSpaceId: String, accountId: String) async throws -> [String: AnyObject] {
            return try await withCheckedThrowingContinuation({ continuation in
                
                do {
                let parameters = JRPCParams(method: "elv_getAccountProfile", params: [contentSpaceId, accountId])

                AF.request(try self.getEndpoint(), method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON { response in
                    //debugPrint("Response: \(response)")
                    
                    switch (response.result) {

                        case .success( _):
                            if let value = response.value as? [String: AnyObject] {
                                //print("Result: \(value["result"])")
                                if let result = value["result"] as? [String: AnyObject] {
                                    continuation.resume(returning: result)
                                }else{
                                    continuation.resume(throwing: FabricError.unexpectedResponse)
                                }
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
    }
    
    struct Message: Decodable, Identifiable {
        let id: Int
        let from: String
        let message: String
    }
    
    func fetchMessages(completion: @escaping ([Message]) -> Void) {
        let url = URL(string: "https://hws.dev/user-messages.json")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let messages = try? JSONDecoder().decode([Message].self, from: data) {
                    completion(messages)
                    return
                }
            }

            completion([])
        }.resume()
    }
    
    // An example error we can throw
    enum FetchError: Error {
        case noMessages
    }

    func fetchMessages() async -> [Message] {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                fetchMessages { messages in
                    if messages.isEmpty {
                        continuation.resume(throwing: FetchError.noMessages)
                    } else {
                        continuation.resume(returning: messages)
                    }
                }
            }
        } catch {
            return [
                Message(id: 1, from: "Tom", message: "Welcome to MySpace! I'm your new friend.")
            ]
        }
    }
}

