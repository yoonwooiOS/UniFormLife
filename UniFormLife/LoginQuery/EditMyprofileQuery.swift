//
//  EditMyprofileQuery.swift
//  UniFormLife
//
//  Created by 김윤우 on 9/1/24.
//

import Foundation

struct EditMyprofileQuery: Encodable {
    let nick: String
    let phoneNum: String
    let birthDay: String
    let profile: Data
}
