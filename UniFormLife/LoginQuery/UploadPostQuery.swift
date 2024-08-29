//
//  UploadPostQuery.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/28/24.
//

import Foundation

struct UploadPostQuery: Encodable {
    let title: String
    let content: String
    let price: Int
    let size: String
    let condition: String
    let season: String
    let league: String
    let imageUrls: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case price
        case size = "content1"
        case condition = "content2"
        case season = "content3"
        case league = "product_id"
        case imageUrls = "files"
    }
}
