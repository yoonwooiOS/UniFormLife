//
//  AddPhotoCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/27/24.
//

import UIKit
import SnapKit
import Then

 final class AddPhotoCollectionViewCell: BaseCollectionViewCell {
    private let baseView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = Color.gray.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    private let camerImageView = UIImageView().then {
        $0.image = UIImage(systemName: "camera")
        $0.tintColor = Color.gray
    }
    private let imageCountLabel = UILabel().then {
        $0.text = "0/5"
        $0.textColor = Color.gray
    }
    override func setUpHierarchy() {
        contentView.addSubview(baseView)
        baseView.addSubview(camerImageView)
        baseView.addSubview(imageCountLabel)
    }
    override func setUpLayout() {
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        camerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(12)
        }
        imageCountLabel.snp.makeConstraints { make in
            make.top.equalTo(camerImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
