//
//  UniformStyleFeedCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class UniformStyleFeedCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let nicknameLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "핫핑"
    }
    private let teamNameLabel = UILabel().then {
        $0.text = "맨시티[12-13]"
    }
    private let couponLabel = UILabel().then {
        $0.text = "20% 쿠폰"
    }
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
}
