//
//  FetchMyProfile.swift
//  UniFormLife
//
//  Created by 김윤우 on 9/1/24.
//

import Foundation

struct FetchMyProfile: Decodable {
    let user_id: String
    let email: String
    let profileImage: String?
    let nick: String
    let followers: [String]
    let following: [String]
    let posts: [String]
}
