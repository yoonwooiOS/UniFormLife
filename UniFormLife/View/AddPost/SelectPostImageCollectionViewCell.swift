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
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    private let cancelImageView = UIImageView().then {
        $0.image = UIImage(systemName: "minus.circle")
        $0.tintColor = .white
        $0.backgroundColor = Color.red
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    private let representativeLabel = UILabel().then {
        $0.text = "대표 사진"
        $0.textColor = .white
        $0.backgroundColor = .black.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.isHidden = true
    }
    override func setUpHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(cancelImageView)
        contentView.addSubview(representativeLabel)
        
    }
    override func setUpLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        cancelImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-8)
            make.trailing.equalToSuperview().offset(8)
            make.width.height.equalTo(20)
        }
        
        representativeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    func setupCell(image: UIImage, index: Int) {
        imageView.image = image
        if index == 1 {
            representativeLabel.isHidden = false
        } else {
            representativeLabel.isHidden = true
        }
    }
}
