//
//  CarmeraImageButton.swift
//  UniFormLife
//
//  Created by 김윤우 on 9/7/24.
//

import UIKit
import SnapKit
import Then

class CarmeraImageButton: UIButton {
    private let baseView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = Color.gray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(systemName: "camera")
        $0.tintColor = Color.gray
    }
    
    private let imageCountLabel = UILabel().then {
        $0.text = "0/5"
        $0.textColor = Color.gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(baseView)
        baseView.addSubview(cameraImageView)
        baseView.addSubview(imageCountLabel)  
    }
    
    private func setupLayout() {
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        }
        
        imageCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
