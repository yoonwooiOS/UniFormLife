//
//  SelectPostImageCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/27/24.
//

import UIKit
import SnapKit
import Then

 class SelectPostImageCollectionViewCell: BaseCollectionViewCell {
     let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
         $0.backgroundColor = .green
        
    }
    private let cancelImageView = UIImageView().then {
        $0.image = UIImage(systemName: "minus")
        $0.backgroundColor = Color.red
    }
    
    override func setUpHierarchy() {
        contentView.addSubview(imageView)
        imageView.addSubview(cancelImageView)
        
    }
    override func setUpLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        cancelImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
    }
}
