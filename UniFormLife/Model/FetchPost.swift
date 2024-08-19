//
//  ImportPostModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/17/24.
//

import Foundation

struct FetchPost: Decodable {
    let data: [PostData]
    let nextCursor: String
    enum CodingKeys: String, CodingKey {
           case data
           case nextCursor = "next_cursor"
       }
}

struct PostData: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
//    let comments: [Comments]

    
}

struct Creator: Codable {
    let user_id: String
    let nick: String
//    let profileImage: String
}

struct Comments: Codable {
    let user_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
