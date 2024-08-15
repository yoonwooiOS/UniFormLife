//
//  ReuseIdentifier.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import Foundation

extension NSObjectProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
