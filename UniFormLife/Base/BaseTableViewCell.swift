//
//  BaseTableViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/14/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setUpHierarchy()
        setUpLayout()
        setUpView()
    }
    
    func setUpHierarchy() { }
    func setUpLayout() { }
    func setUpView() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
