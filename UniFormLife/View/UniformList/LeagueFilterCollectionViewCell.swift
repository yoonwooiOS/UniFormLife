//
//  LeagueFilterCollectionViewCell.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/18/24.
//

import UIKit
import SnapKit

final class LeagueFilterCollectionViewCell: BaseCollectionViewCell {
    let leagueImageView = {
        let view = UIImageView()
//        view.backgroundColor = .blue
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 26
        return view
    }()
    
    override func setUpHierarchy() {
        contentView.addSubview(leagueImageView)
    }
    override func setUpLayout() {
        leagueImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
