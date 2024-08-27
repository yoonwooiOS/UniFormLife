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
        view.contentMode = .scaleToFill
        return view
    }()
    
    override func setUpHierarchy() {
        contentView.addSubview(leagueImageView)
    }
    override func setUpLayout() {
        leagueImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
