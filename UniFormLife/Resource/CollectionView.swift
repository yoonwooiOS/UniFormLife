//
//  CollectionView.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/24/24.
//

import UIKit

enum CollectionView {
    static func leagueCollectionViewlayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 12
        let cellSpacing: CGFloat = 8
        //        let size = UIScreen.main.bounds.width -  (cellSpacing)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    static func uniformLayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 4
        let cellSpacing: CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 176, height: 200)
        layout.scrollDirection = .vertical // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
}
