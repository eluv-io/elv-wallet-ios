//
//  FabricModels.swift
//  EluvioWalletIOS
//
//  Created by Wayne Tran on 2021-11-02.
//

import Foundation

struct AppConfiguration: Codable {
    var config_url=""
}

struct LoginResponse: Codable {
    var addr: String
    var eth: String
    var token: String
    
}
