//
//  ProfileModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import Foundation

struct ProfileModel: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email,nick
    }
}
