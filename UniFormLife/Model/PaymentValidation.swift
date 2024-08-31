//
//  PaymentValidation.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/31/24.
//

import Foundation

struct PaymentValidation: Decodable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
