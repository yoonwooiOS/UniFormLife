//
//  UniformListCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/18/24.
//

import UIKit
import SnapKit
import Kingfisher
final class UniformListCollectionViewCell: BaseCollectionViewCell {
    let baseView = {
        let view = UIView()
        return view
    }()
    let uniformImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        //        view.backgroundColor = Color.darkGray
        return view
    }()
    let titleLabel = {
        let label = UILabel()
        label.font = Font.regular15
        label.numberOfLines = 2
        return label
    }()
    let priceLabel = {
        let label = UILabel()
        label.font = Font.bold14
        
        return label
    }()
    let usedLabel = {
        let label = AddPaddingLabel()
        return label
    }()
    let sizeLabel = {
        let label = AddPaddingLabel()
        return label
    }()
    let yearLabel = {
        let label = AddPaddingLabel()
        return label
    }()
    
    override func setUpHierarchy() {
        contentView.addSubview(uniformImageView)
        contentView.addSubview(baseView)
        [titleLabel, usedLabel, priceLabel,sizeLabel, yearLabel ].forEach {
            baseView.addSubview($0)
        }
    }
    override func setUpLayout() {
        uniformImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        baseView.snp.makeConstraints { make in
            make.top.equalTo(uniformImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
        }
        usedLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.equalToSuperview()
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.equalTo(usedLabel.snp.trailing).offset(4)
        }
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.equalTo(sizeLabel.snp.trailing).offset(4)
        }
    }
    func setUpCell(data: PostData) {
        titleLabel.text = data.title
        usedLabel.text = data.content1
        priceLabel.text = data.price.formatted() + "원"
        sizeLabel.text = data.content2
        yearLabel.text = data.content3
        let imageDownloadRequest = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsManeger.shared.token, forHTTPHeaderField: "Authorization")
            request.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            return request
        }
        guard let url = URL(string: APIKey.baseURL + "v1/" + data.files[0] ) else {
            print("Invalid URL")
            return
        }
        uniformImageView.kf.setImage(with: url, options: [.requestModifier(imageDownloadRequest)])
        
    }
}

