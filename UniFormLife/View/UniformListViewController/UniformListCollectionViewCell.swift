//
//  UniformListCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/18/24.
//

import UIKit
import SnapKit

final class UniformListCollectionViewCell: BaseCollectionViewCell {
    let baseView = {
        let view = UIView()
        return view
    }()
    let uniformImageView = {
        let view = UIImageView()
        
        return view
    }()
    let titleLabel = {
        let label = UILabel()
        return label
    }()
    let usedLabel = {
        let label = UILabel()
        return label
    }()
    let priceLabel = {
        let label = UILabel()
        return label
    }()
    
    override func setUpHierarchy() {
        contentView.addSubview(uniformImageView)
        contentView.addSubview(baseView)
        [titleLabel, usedLabel, priceLabel].forEach {
            baseView.addSubview($0)
        }
    }
    override func setUpLayout() {
        uniformImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.size.equalTo(60)
        }
        baseView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(uniformImageView.snp.trailing).offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(20)
        }
        usedLabel.snp.makeConstraints { make in
            
        }
    }
}
