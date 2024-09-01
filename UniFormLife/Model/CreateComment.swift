//
//  CreateComment.swift
//  UniFormLife
//
//  Created by 김윤우 on 9/1/24.
//

import Foundation

struct CreateComment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
