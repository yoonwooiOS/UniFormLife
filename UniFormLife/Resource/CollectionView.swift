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
        layout.itemSize = CGSize(width: 72, height: 72)
        layout.scrollDirection = .horizontal // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    static func uniformLayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 4
        let cellSpacing: CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 176, height: 280)
        layout.scrollDirection = .vertical // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    static func addPhotoLayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 16
           let cellSpacing: CGFloat = 8
           let itemWidth: CGFloat = 60
           let itemHeight: CGFloat = 60
           
           let layout = UICollectionViewFlowLayout()
           layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
           layout.scrollDirection = .horizontal
           layout.minimumLineSpacing = cellSpacing
           layout.minimumInteritemSpacing = cellSpacing
           layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
           return layout
    }
    static func UniformStyleFeedLayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 4
        let cellSpacing: CGFloat = 4
        let screenWidth = UIScreen.main.bounds.width - (sectionSpacing * 2)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth * 1.3)
        layout.scrollDirection = .vertical // 가로 간격
        layout.minimumLineSpacing = cellSpacing // 세로 간격
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }

    static func recommandCollectionViewLayout() -> UICollectionViewLayout {
        let sectionSpacing: CGFloat = 4
        let cellSpacing: CGFloat = 8
        let cellsPerRow: CGFloat = 2
        let screenWidth = UIScreen.main.bounds.width - (sectionSpacing * 2)
        let cellWidth = floor((screenWidth - (cellSpacing * (cellsPerRow - 1))) / cellsPerRow)
        let cellHeight = cellWidth * 1.5

        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
}
