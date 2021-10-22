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
    var display_name = ""
    var description = ""
    var address = ""
    var edition_name = ""
    var external_url = ""
    var creator = ""
    var created_at = ""
    var copyright = ""
    var embed_url = ""
    var image = ""
    var total_supply=0
    var edition_number=0
    var price_tokens=0.0
    var is_for_sale=false
}
