//
//  BaseCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setUpHierarchy()
        setUpLayout()
    }
    
    func setUpHierarchy() { }
    func setUpLayout() { }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

