//
//  DetailViewRecommandCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/31/24.
//

import UIKit
import Then
import SnapKit

final class DetailViewRecommandCollectionViewCell: BaseCollectionViewCell {
    let uniformImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
//        $0.backgroundColor = .brown
    }
    let titleLabel = UILabel().then {
        $0.font = Font.regular12
        $0.numberOfLines = 1
    }
    let priceLabel = UILabel().then {
        $0.font = Font.bold14
    }
    override func setUpHierarchy() {
        contentView.addSubview(uniformImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    override func setUpLayout() {
        uniformImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(uniformImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
    }

    func setUpCell(data: PostData) {
        
        if data.files.isEmpty {
            uniformImageView.image = UIImage(named: "man1")
        } else {
            print("Image URL: \(data.files[0])") // 디버깅을 위한 출력
            uniformImageView.setDownloadToImageView(urlString: data.files[0])
        }
        titleLabel.text = data.title
        priceLabel.text = data.price.formatted() + "원"
       
        
    }
}
