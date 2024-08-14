//
//  InputOutputViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import Foundation

protocol InputOutputViewModel {
    associatedtype Input
    associatedtype Output
    func transfrom(input: Input) -> Output
}
