//
//  LikePost.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/26/24.
//

import Foundation

struct LikePost: Decodable {
    let likeStatus: Bool
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
