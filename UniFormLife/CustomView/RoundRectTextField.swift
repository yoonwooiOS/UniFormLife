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
        addDoneToolbar()
    }
    private func addDoneToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = Color.red
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = Color.black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 툴바에 버튼 추가
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        self.inputAccessoryView = toolbar
        
    }
    @objc private func cancelButtonTapped() {
        self.text = ""
        self.resignFirstResponder()
    }
    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
