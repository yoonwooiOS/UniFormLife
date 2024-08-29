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
    let baseView = UIView()
    let uniformImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }

    let titleLabel = UILabel().then {
        $0.font = Font.regular14
        $0.numberOfLines = 1
    }

    let priceLabel = UILabel().then {
        $0.font = Font.bold14
    }

    lazy var usedLabel = TagImageView(text: "", backgroundColor: UIColor(red: 1.0, green: 0.61, blue: 0.45, alpha: 1.0))
    let sizeLabel = AddPaddingLabel()
    let yearLabel = AddPaddingLabel()
    var isTradingLabel = TagImageView(text: "거래가능", backgroundColor: .systemGreen)
    override func setUpHierarchy() {
        contentView.addSubview(uniformImageView)
        contentView.addSubview(baseView)
        [titleLabel, priceLabel,sizeLabel, yearLabel ].forEach {
            baseView.addSubview($0)
        }
        uniformImageView.addSubview(usedLabel)
        uniformImageView.addSubview(isTradingLabel)
        
    }
    override func setUpLayout() {
        uniformImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        baseView.snp.makeConstraints { make in
            make.top.equalTo(uniformImageView.snp.bottom).offset(4)
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
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.equalToSuperview()
           
        }
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.equalTo(sizeLabel.snp.trailing).offset(4)
        }
        usedLabel.snp.makeConstraints { make in
            make.bottom.equalTo(uniformImageView.snp.bottom).inset(4)
            make.leading.equalToSuperview().offset(4)
        }
        isTradingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(uniformImageView.snp.bottom).inset(4)
            make.leading.equalTo(usedLabel.snp.trailing).offset(4)
            
        }
    }
    func setUpCell(data: PostData) {
       
        titleLabel.text = data.title
        usedLabel.updateText(text: data.content2)
        priceLabel.text = data.price.formatted() + "원"
        sizeLabel.text = data.content1
        yearLabel.text = data.content3
        if data.likes2.count == 0 {
            isTradingLabel = TagImageView(text: "거래가능", backgroundColor: .systemGreen)
        } else {
            isTradingLabel = TagImageView(text: "거래완료", backgroundColor: .systemOrange)
        }
        
        uniformImageView.setDownloadToImageView(urlString: data.files[0])
    }
   
}

