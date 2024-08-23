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
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        baseView.snp.makeConstraints { make in
           
            
        }
        titleLabel.snp.makeConstraints { make in
           
        }
        priceLabel.snp.makeConstraints { make in
           
        }
    }
    func setUpCell(data: PostData) {
        titleLabel.text = data.title
        
        priceLabel.text = data.price.formatted() + "원"
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
