//
//  NFTModel.swift
//  NFTModel
//
//  Created by Wayne Tran on 2021-08-11.
//

import Foundation
import SwiftUI

struct NFTModel: Identifiable, Codable {
    var id = ""
    var versionHash = ""
    var edition_number=0
    var price_tokens=0.0
    var is_for_sale=false
    var metadata : NFTMetaResponse = NFTMetaResponse()
}
