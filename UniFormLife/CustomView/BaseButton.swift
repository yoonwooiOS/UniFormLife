//
//  BaseButton.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/15/24.
//

import UIKit

class BaseButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Color.white, for: .normal)
        backgroundColor = Color.black
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
