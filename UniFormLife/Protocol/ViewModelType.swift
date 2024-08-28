//
//  ViewModelType.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
