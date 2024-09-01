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
    private let uniformImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    private let titleLabel = UILabel().then {
        $0.text = "파리생제르망 PSG홈 유니폼 저지 20-21 팝니다"
        $0.numberOfLines = 2
        $0.font = Font.regular12
    }
    private let priceLabel = UILabel().then {
        $0.text = "119,000원"
        $0.font = Font.regular12
    }
    override func setUpHierarchy() {
        contentView.addSubview(uniformImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    override func setUpLayout() {
        uniformImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(uniformImageView.snp.bottom).offset(2)
        }
        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
    }
}
