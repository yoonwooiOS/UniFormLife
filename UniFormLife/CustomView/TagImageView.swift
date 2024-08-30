//
//  TagImageView.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class TagImageView: UIView {
    
    private let label = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .center
    }
    
    init(text: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupView(text: text, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(text: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        label.text = text
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func updateText(text: String, backgroundColor: UIColor? = nil) {
        label.text = text
        if let bgColor = backgroundColor {
            self.backgroundColor = bgColor
        }
    }
}
