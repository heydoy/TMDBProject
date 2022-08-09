//
//  CircularCollectionViewLayout.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/06.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {
    let itemSize = CGSize(width: 300, height: 420)
    
    var radius: CGFloat = 500 {
      didSet {
        invalidateLayout()
      }
    }
    
    var anglePerItem: CGFloat {
      return atan(itemSize.width / radius)
    }
    
    func collectionViewContentSize() -> CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                      height: collectionView!.bounds.height)
    }
}


