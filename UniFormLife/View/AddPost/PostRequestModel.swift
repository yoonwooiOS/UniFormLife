//
//  PostRequestModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/28/24.
//

import Foundation

struct PostRequestModel: Decodable {
    let title: String
    let content: String
    let price: String
    let size: String
    let condition: String
    let season: String
    let league: String
    let files: [String]
}
