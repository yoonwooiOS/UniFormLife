//
//  RoundRectTextField.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/27/24.
//

import UIKit

final class RoundRectTextField: UITextField {
    
    init(_ placeholderText: String, inputView: UIPickerView?) {
        super.init(frame: .zero)
        
        placeholder = placeholderText
        borderStyle = .roundedRect
        textColor = .black
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        self.inputView = inputView
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
