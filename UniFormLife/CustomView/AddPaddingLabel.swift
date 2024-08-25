//
//  AddPaddingLabel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/24/24.
//

import UIKit

class AddPaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

     init() {
         super.init(frame: .zero)
        self.font = Font.regular13
        self.textColor = Color.gray
        self.textAlignment = .left
        self.layer.borderWidth = 1
        self.layer.borderColor = Color.black.cgColor
        
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
